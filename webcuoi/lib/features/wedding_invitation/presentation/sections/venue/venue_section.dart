import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/invitation_api.dart';
import '../../widgets/embedded_map.dart';
import '../../widgets/scroll_visibility.dart';
import '../section_theme.dart';

class VenuePlace {
  const VenuePlace({
    required this.side,
    required this.title,
    required this.address,
    this.directionsUrl,
    this.embedUrl,
    this.placeId = '',
    this.latitude,
    this.longitude,
  });

  final String side;
  final String title;
  final String address;
  final String? directionsUrl;
  final String? embedUrl;
  final String placeId;
  final double? latitude;
  final double? longitude;

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude!.isFinite &&
      longitude!.isFinite;

  String get mapQuery {
    if (hasCoordinates) {
      return '$latitude,$longitude';
    }
    return address;
  }

  Uri get directionsUri {
    final fromApi = Uri.tryParse(directionsUrl ?? '');
    if (!hasCoordinates &&
        fromApi != null &&
        fromApi.hasScheme &&
        fromApi.host.isNotEmpty) {
      return fromApi;
    }

    return Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': mapQuery.isNotEmpty ? mapQuery : title,
    });
  }

  factory VenuePlace.fromJson(Map<String, dynamic> json) {
    final mapsValue = json['maps'];
    final maps = mapsValue is Map
        ? Map<String, dynamic>.from(mapsValue)
        : const <String, dynamic>{};
    final side = json['side']?.toString() ?? 'groom';

    return VenuePlace(
      side: side,
      title: json['title']?.toString() ?? _titleFor(side),
      address: json['address']?.toString() ?? '',
      directionsUrl: maps['directionsUrl']?.toString(),
      embedUrl: maps['embedUrl']?.toString(),
      placeId: json['placeId']?.toString() ?? '',
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
    );
  }

  static String _titleFor(String side) =>
      side == 'bride' ? 'Địa chỉ nhà gái' : 'Địa chỉ nhà trai';

  static double? _asDouble(dynamic value) =>
      value is num ? value.toDouble() : null;
}

class VenueSection extends StatefulWidget {
  const VenueSection({
    super.key,
    required this.scale,
    this.places = _defaultPlaces,
    this.loadFromServer = true,
  });

  final double scale;
  final List<VenuePlace> places;
  final bool loadFromServer;

  static const List<VenuePlace> _defaultPlaces = [
    VenuePlace(
      side: 'groom',
      title: 'Địa chỉ nhà trai',
      address: '300 Đ. Thân Công Tài',
      latitude: 21.212936479442916,
      longitude: 106.09532359291711,
    ),
    VenuePlace(
      side: 'bride',
      title: 'Địa chỉ nhà gái',
      address: 'Tổ Dân Phố Dĩnh Sơn, Phường Vân Hà, Thành phố Bắc Ninh',
      latitude: 21.256900289911776,
      longitude: 106.05149489064672,
    ),
  ];

  @override
  State<VenueSection> createState() => _VenueSectionState();
}

class _VenueSectionState extends State<VenueSection>
    with WidgetsBindingObserver {
  late List<VenuePlace> _places;
  String _selectedSide = 'groom';
  late final ScrollViewportObserver _viewportObserver = ScrollViewportObserver(
    _updateVisibility,
  );
  ScrollPosition? get _scrollPosition => _viewportObserver.position;
  bool _isVisible = false;
  bool _mapActivated = false;
  bool _isAppVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState != null) {
      _isAppVisible = _isVisibleLifecycle(lifecycleState);
    }
    _places = widget.places;
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
    if (widget.loadFromServer) unawaited(_loadPlaces());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewportObserver.attach(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewportObserver.dispose();
    super.dispose();
  }

  void _updateVisibility() {
    if (!mounted) return;
    final visible = isInScrollViewport(context, _scrollPosition);
    if (visible == _isVisible) return;

    setState(() {
      _isVisible = visible;
      if (!visible) _mapActivated = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isVisible = _isVisibleLifecycle(state);
    if (isVisible == _isAppVisible) return;
    setState(() {
      _isAppVisible = isVisible;
      if (!isVisible) _mapActivated = false;
    });
  }

  bool _isVisibleLifecycle(AppLifecycleState state) =>
      state != AppLifecycleState.hidden &&
      state != AppLifecycleState.paused &&
      state != AppLifecycleState.detached;

  VenuePlace get _selectedPlace => _places.firstWhere(
    (place) => place.side == _selectedSide,
    orElse: () => _places.first,
  );

  Future<void> _loadPlaces() async {
    try {
      final locations = await InvitationApi.loadFamilyMaps();
      final fromServer = locations
          .map(VenuePlace.fromJson)
          .where(
            (place) =>
                (place.side == 'groom' || place.side == 'bride') &&
                place.mapQuery.isNotEmpty,
          )
          .toList();
      if (fromServer.isEmpty || !mounted) return;

      final bySide = {for (final place in fromServer) place.side: place};
      final defaultsBySide = {
        for (final place in VenueSection._defaultPlaces) place.side: place,
      };
      setState(() {
        _places = [
          bySide['groom'] ?? defaultsBySide['groom']!,
          bySide['bride'] ?? defaultsBySide['bride']!,
        ];
      });
    } catch (error) {
      debugPrint('Could not load family map addresses: $error');
    }
  }

  Future<void> _openDirections(VenuePlace place) async {
    final opened = await launchUrl(
      place.directionsUri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Không thể mở bản đồ.')));
    }
  }

  void _selectSide(String side) {
    if (side == _selectedSide) return;
    setState(() => _selectedSide = side);
  }

  @override
  Widget build(BuildContext context) {
    final place = _selectedPlace;
    final textScale = math.max(widget.scale, 0.9).toDouble();
    final isMobile = MediaQuery.widthOf(context) <= 720;
    final mapLoaded =
        _isVisible && _isAppVisible && (!isMobile || _mapActivated);
    final card = _VenueCard(
      key: ValueKey(place.side),
      place: place,
      scale: widget.scale,
      textScale: textScale,
      mapLoaded: mapLoaded,
      isMobile: isMobile,
      onActivateMap: () => setState(() => _mapActivated = true),
      onCloseMap: () => setState(() => _mapActivated = false),
      onOpenDirections: () => _openDirections(place),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 28 * widget.scale),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 550 * widget.scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'TI\u{1EC6}C C\u{01AF}\u{1EDA}I S\u{1EBC} T\u{1ED4} CH\u{1EE8}C T\u{1EA0}I',
                textAlign: TextAlign.center,
                style: SectionTheme.label(widget.scale),
              ),
              SizedBox(height: 12 * widget.scale),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: _FamilyToggle(
                    selectedSide: _selectedSide,
                    scale: widget.scale,
                    onSelected: _selectSide,
                  ),
                ),
              ),
              SizedBox(height: 14 * widget.scale),
              if (isMobile)
                card
              else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: card,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({
    super.key,
    required this.place,
    required this.scale,
    required this.textScale,
    required this.mapLoaded,
    required this.isMobile,
    required this.onActivateMap,
    required this.onCloseMap,
    required this.onOpenDirections,
  });

  final VenuePlace place;
  final double scale;
  final double textScale;
  final bool mapLoaded;
  final bool isMobile;
  final VoidCallback onActivateMap;
  final VoidCallback onCloseMap;
  final VoidCallback onOpenDirections;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          place.title,
          textAlign: TextAlign.center,
          style: SectionTheme.body(scale).copyWith(
            fontSize: 15 * textScale,
            fontWeight: FontWeight.w600,
            color: SectionTheme.inkSoft,
            letterSpacing: 0.35 * scale,
          ),
        ),
        SizedBox(height: 6 * scale),
        Text(
          place.address,
          textAlign: TextAlign.center,
          style: SectionTheme.body(scale).copyWith(
            fontSize: 14 * textScale,
            color: SectionTheme.inkSoft,
            height: 1.4,
          ),
        ),
        SizedBox(height: 16 * scale),
        LayoutBuilder(
          builder: (context, constraints) {
            final mapHeight = constraints.maxWidth / 1.48;
            return SizedBox(
              height: mapHeight,
              width: double.infinity,
              child: mapLoaded
                  ? EmbeddedMap(
                      key: ValueKey('map-${place.side}-${place.mapQuery}'),
                      query: place.mapQuery,
                      embedUrl: place.hasCoordinates ? null : place.embedUrl,
                      height: mapHeight,
                      borderRadius: 2 * scale,
                    )
                  : Material(
                      color: const Color(0xFFE9E0D2),
                      borderRadius: BorderRadius.circular(2 * scale),
                      child: InkWell(
                        onTap: isMobile ? onActivateMap : null,
                        borderRadius: BorderRadius.circular(2 * scale),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.map_outlined,
                                color: SectionTheme.inkSoft,
                                size: 28,
                              ),
                              if (isMobile) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Chạm để xem bản đồ',
                                  textAlign: TextAlign.center,
                                  style: SectionTheme.body(scale).copyWith(
                                    fontSize: 14 * textScale,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
            );
          },
        ),
        if (isMobile && mapLoaded)
          TextButton.icon(
            onPressed: onCloseMap,
            style: TextButton.styleFrom(
              foregroundColor: SectionTheme.ink,
              minimumSize: const Size(44, 44),
            ),
            icon: const Icon(Icons.close_rounded, size: 17),
            label: const Text('Đóng bản đồ để cuộn thiệp'),
          ),
        SizedBox(height: 14 * scale),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24 * scale),
            onTap: onOpenDirections,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * scale,
                vertical: 7 * scale,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.directions_outlined,
                    size: 19 * textScale,
                    color: SectionTheme.inkSoft,
                  ),
                  SizedBox(width: 8 * scale),
                  Text(
                    'Ch\u{1EC9} \u{0111}\u{01B0}\u{1EDD}ng',
                    style: SectionTheme.body(scale).copyWith(
                      color: SectionTheme.inkSoft,
                      fontSize: 15 * textScale,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3 * scale,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FamilyToggle extends StatelessWidget {
  const _FamilyToggle({
    required this.selectedSide,
    required this.scale,
    required this.onSelected,
  });

  final String selectedSide;
  final double scale;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textScale = math.max(scale, 0.9).toDouble();

    return Container(
      height: math.max(42.0, 44 * scale).toDouble(),
      padding: EdgeInsets.all(4 * scale),
      decoration: BoxDecoration(
        color: SectionTheme.paperCard,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: SectionTheme.hairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSegment(
              label: 'Nh\u{00E0} trai',
              selected: selectedSide == 'groom',
              textScale: textScale,
              onTap: () => onSelected('groom'),
            ),
          ),
          Expanded(
            child: _ToggleSegment(
              label: 'Nh\u{00E0} g\u{00E1}i',
              selected: selectedSide == 'bride',
              textScale: textScale,
              onTap: () => onSelected('bride'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.label,
    required this.selected,
    required this.textScale,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final double textScale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? SectionTheme.ink : Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: SizedBox.expand(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home_outlined,
                size: 17 * textScale,
                color: selected ? Colors.white : SectionTheme.inkSoft,
              ),
              const SizedBox(width: 6),
              Text(
                label,  
                style: TextStyle(
                  color: selected ? Colors.white : SectionTheme.inkSoft,
                  fontFamily: SectionTheme.fontFamilyFor(context),
                  fontSize: 13 * textScale,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
