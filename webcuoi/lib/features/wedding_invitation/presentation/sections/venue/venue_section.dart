import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/invitation_api.dart';
import '../../widgets/embedded_map.dart';
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

  String get mapQuery {
    if (latitude != null && longitude != null) {
      return '$latitude,$longitude';
    }
    return address;
  }

  Uri get directionsUri {
    final fromApi = Uri.tryParse(directionsUrl ?? '');
    if (fromApi != null && fromApi.hasScheme && fromApi.host.isNotEmpty) {
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
      address: 'Số 300 đường Thân Công Tài, Phường Nếnh, Thành phố Bắc Ninh',
    ),
    VenuePlace(
      side: 'bride',
      title: 'Địa chỉ nhà gái',
      address: 'Tổ Dân Phố Dĩnh Sơn, Phường Vân Hà, Thành phố Bắc Ninh',
    ),
  ];

  @override
  State<VenueSection> createState() => _VenueSectionState();
}

class _VenueSectionState extends State<VenueSection> {
  late List<VenuePlace> _places;
  String _selectedSide = 'groom';

  @override
  void initState() {
    super.initState();
    _places = widget.places;
    if (widget.loadFromServer) unawaited(_loadPlaces());
  }

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
              SizedBox(height: 18 * widget.scale),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _VenueCard(
                  key: ValueKey(place.side),
                  place: place,
                  scale: widget.scale,
                  textScale: textScale,
                  onOpenDirections: () => _openDirections(place),
                ),
              ),
              SizedBox(height: 10 * widget.scale),
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
    required this.onOpenDirections,
  });

  final VenuePlace place;
  final double scale;
  final double textScale;
  final VoidCallback onOpenDirections;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16 * scale,
        vertical: 14 * scale,
      ),
      decoration: BoxDecoration(
        color: SectionTheme.paperCard,
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: SectionTheme.hairline),
      ),
      child: Column(
        children: [
          Text(
            place.title,
            textAlign: TextAlign.center,
            style: SectionTheme.body(scale).copyWith(
              fontSize: 15 * textScale,
              fontWeight: FontWeight.w600,
              color: SectionTheme.ink,
              letterSpacing: 0.35 * scale,
            ),
          ),
          SizedBox(height: 8 * scale),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 19 * textScale,
                color: SectionTheme.inkSoft,
              ),
              SizedBox(width: 7 * scale),
              Expanded(
                child: Text(
                  place.address,
                  textAlign: TextAlign.center,
                  style: SectionTheme.body(scale).copyWith(
                    fontSize: 14 * textScale,
                    color: SectionTheme.inkSoft,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * scale),
          LayoutBuilder(
            builder: (context, constraints) {
              // Match the broad map frame from the reference and fill it edge to edge.
              final mapHeight = constraints.maxWidth / 1.48;
              return EmbeddedMap(
                key: ValueKey('map-${place.side}-${place.mapQuery}'),
                query: place.mapQuery,
                embedUrl: place.embedUrl,
                height: mapHeight,
                borderRadius: 10 * scale,
              );
            },
          ),
          SizedBox(height: 12 * scale),
          Material(
            color: SectionTheme.ink,
            borderRadius: BorderRadius.circular(24 * scale),
            child: InkWell(
              borderRadius: BorderRadius.circular(24 * scale),
              onTap: onOpenDirections,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20 * scale,
                  vertical: 9 * scale,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_outlined,
                      size: 19 * textScale,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8 * scale),
                    Text(
                      'Chỉ đường',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15 * textScale,
                        letterSpacing: 0.3 * scale,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
                color: selected ? Colors.white : SectionTheme.ink,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : SectionTheme.ink,
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
