import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/embedded_map.dart';
import '../section_theme.dart';

/// Thông tin một địa điểm (nhà gái / nhà trai).
class VenuePlace {
  const VenuePlace({required this.title, required this.address});

  final String title;
  final String address;

  /// Link Google Maps tìm theo địa chỉ.
  Uri get mapUri => Uri.parse(
    'https://www.google.com/maps/search/?api=1'
    '&query=${Uri.encodeComponent(address)}',
  );
}

/// Section — ĐỊA ĐIỂM TIỆC CƯỚI (theo Figma):
/// Hiển thị địa chỉ nhà gái và nhà trai, mỗi nơi có nút "Chỉ đường"
/// mở Google Maps ở tab/ứng dụng bản đồ.
class VenueSection extends StatelessWidget {
  const VenueSection({super.key, required this.scale, this.places = _defaultPlaces});

  final double scale;
  final List<VenuePlace> places;

  static const List<VenuePlace> _defaultPlaces = [
    VenuePlace(
      title: '\u{0110}\u{1ECB}a ch\u{1EC9} nh\u{00E0} g\u{00E1}i',
      address:
          'T\u{1ED5} D\u{00E2}n Ph\u{1ED1} D\u{0129}nh S\u{01A1}n, '
          'Ph\u{01B0}\u{1EDD}ng V\u{00E2}n H\u{00E0}, '
          'Th\u{00E0}nh ph\u{1ED1} B\u{1EAF}c Ninh',
    ),
    VenuePlace(
      title: '\u{0110}\u{1ECB}a ch\u{1EC9} nh\u{00E0} trai',
      address:
          'S\u{1ED1} 300 \u{0111}\u{01B0}\u{1EDD}ng Th\u{00E2}n C\u{00F4}ng T\u{00E0}i, '
          'Ph\u{01B0}\u{1EDD}ng N\u{1EBF}nh, '
          'Th\u{00E0}nh ph\u{1ED1} B\u{1EAF}c Ninh',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 36 * scale),
      child: Column(
        children: [
          Text(
            'TI\u{1EC6}C C\u{01AF}\u{1EDA}I S\u{1EBC} T\u{1ED4} CH\u{1EE8}C T\u{1EA0}I',
            textAlign: TextAlign.center,
            style: SectionTheme.label(scale),
          ),
          SizedBox(height: 24 * scale),
          LayoutBuilder(
            builder: (context, constraints) {
              // Đủ rộng -> xếp 2 thẻ thành hàng ngang; hẹp -> xếp dọc.
              final wide = constraints.maxWidth >= 620;
              if (wide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < places.length; i++) ...[
                        if (i > 0) SizedBox(width: 20 * scale),
                        Expanded(
                          child: _VenueCard(place: places[i], scale: scale),
                        ),
                      ],
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  for (final place in places)
                    Padding(
                      padding: EdgeInsets.only(bottom: 16 * scale),
                      child: _VenueCard(place: place, scale: scale),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.place, required this.scale});

  final VenuePlace place;
  final double scale;

  Future<void> _openMap(BuildContext context) async {
    final ok = await launchUrl(
      place.mapUri,
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kh\u{00F4}ng th\u{1EC3} m\u{1EDF} b\u{1EA3}n \u{0111}\u{1ED3}.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18 * scale, vertical: 18 * scale),
      decoration: BoxDecoration(
        color: SectionTheme.paperCard,
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(color: SectionTheme.hairline),
      ),
      child: Column(
        children: [
          Text(
            place.title,
            textAlign: TextAlign.center,
            style: SectionTheme.body(scale).copyWith(
              fontSize: 15 * scale,
              fontWeight: FontWeight.w600,
              color: SectionTheme.ink,
              letterSpacing: 0.5 * scale,
            ),
          ),
          SizedBox(height: 8 * scale),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18 * scale,
                color: SectionTheme.inkSoft,
              ),
              SizedBox(width: 6 * scale),
              Flexible(
                child: Text(
                  place.address,
                  textAlign: TextAlign.center,
                  style: SectionTheme.body(scale).copyWith(
                    fontSize: 14 * scale,
                    color: SectionTheme.inkSoft,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * scale),

          // Bản đồ Google Maps nhúng (nền).
          EmbeddedMap(
            query: place.address,
            height: 190 * scale,
            borderRadius: 10 * scale,
          ),
          SizedBox(height: 14 * scale),

          // Nút "Chỉ đường" mở Google Maps.
          Material(
            color: SectionTheme.ink,
            borderRadius: BorderRadius.circular(22 * scale),
            child: InkWell(
              borderRadius: BorderRadius.circular(22 * scale),
              onTap: () => _openMap(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 22 * scale,
                  vertical: 11 * scale,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_outlined,
                      size: 18 * scale,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8 * scale),
                    Text(
                      'Ch\u{1EC9} \u{0111}\u{01B0}\u{1EDD}ng',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15 * scale,
                        letterSpacing: 0.5 * scale,
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
