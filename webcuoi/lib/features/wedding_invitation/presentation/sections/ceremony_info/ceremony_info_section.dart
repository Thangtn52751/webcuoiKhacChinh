import 'package:flutter/material.dart';

import '../section_theme.dart';

/// Section 2 — THÔNG TIN LỄ CƯỚI (theo Figma):
/// Thẻ giấy kem ghi tên song thân hai họ, lời báo tin, tên cô dâu chú rể,
/// thời gian và địa điểm cử hành lễ, kèm ngày âm lịch.
/// Hai bên thẻ có nhành hoa khô trang trí.
class CeremonyInfoSection extends StatelessWidget {
  const CeremonyInfoSection({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final cardWidth = 340.0 * scale;
    final flowerWidth = 90.0 * scale;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32 * scale),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          _buildCard(cardWidth),
          // Hoa khô bên trái (lật ngang), nghiêng nhẹ.
          Positioned(
            left: -flowerWidth * 0.35,
            top: 60 * scale,
            child: Transform.rotate(
              angle: -0.15,
              child: Transform.flip(
                flipX: true,
                child: Image.asset(
                  'assets/images/decorations/dried_flower.png',
                  width: flowerWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Hoa khô bên phải.
          Positioned(
            right: -flowerWidth * 0.35,
            top: 40 * scale,
            child: Transform.rotate(
              angle: 0.12,
              child: Image.asset(
                'assets/images/decorations/dried_flower.png',
                width: flowerWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(double cardWidth) {
    return Container(
      width: cardWidth,
      padding: EdgeInsets.symmetric(horizontal: 28 * scale, vertical: 32 * scale),
      decoration: BoxDecoration(
        color: SectionTheme.paperCard,
        borderRadius: BorderRadius.circular(6 * scale),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F5A473B),
            blurRadius: 18 * scale,
            offset: Offset(0, 8 * scale),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('TH\u{00D4}NG TIN L\u{1EC4} C\u{01AF}\u{1EDA}I',
              style: SectionTheme.label(scale)),
          SizedBox(height: 22 * scale),

          // Song thân hai họ.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _family(
                  side: 'Nh\u{00E0} Trai',
                  parents: const ['Nguy\u{1EC5}n Kh\u{1EAF}c Ph\u{00FA}c',
                      'Nguy\u{1EC5}n Th\u{1ECB} Chang'],
                ),
              ),
              Expanded(
                child: _family(
                  side: 'Nh\u{00E0} G\u{00E1}i',
                  parents: const ['Ph\u{1EA1}m Th\u{1ECB} Lan'],
                ),
              ),
            ],
          ),
          SizedBox(height: 24 * scale),

          Text(
            'Tr\u{00E2}n tr\u{1ECD}ng b\u{00E1}o tin\nl\u{1EC5} th\u{00E0}nh h\u{00F4}n c\u{1EE7}a con ch\u{00FA}ng t\u{00F4}i',
            textAlign: TextAlign.center,
            style: SectionTheme.body(scale).copyWith(
              color: SectionTheme.inkSoft,
              fontSize: 13 * scale,
              letterSpacing: 1 * scale,
            ),
          ),
          SizedBox(height: 20 * scale),

          // Tên cô dâu chú rể.
          Text('Nguy\u{1EC5}n Kh\u{1EAF}c Ch\u{00ED}nh',
              style: SectionTheme.displayName(scale).copyWith(fontSize: 24 * scale)),
          SizedBox(height: 4 * scale),
          Text('&',
              style: SectionTheme.displayName(scale).copyWith(fontSize: 20 * scale)),
          SizedBox(height: 4 * scale),
          Text('Nguy\u{1EC5}n Th\u{1ECB} Trang',
              style: SectionTheme.displayName(scale).copyWith(fontSize: 24 * scale)),
          SizedBox(height: 22 * scale),

          Text(
            'L\u{1EC4} TH\u{00C0}NH H\u{00D4}N \u{0110}\u{01AF}\u{1EE2}C C\u{1EEC} H\u{00C0}NH T\u{1EA0}I T\u{01AF} GIA',
            textAlign: TextAlign.center,
            style: SectionTheme.body(scale).copyWith(
              fontSize: 12 * scale,
              letterSpacing: 1.5 * scale,
              color: SectionTheme.inkSoft,
            ),
          ),
          SizedBox(height: 14 * scale),

          Text('V\u{00C0}O L\u{00DA}C',
              style: SectionTheme.body(scale)
                  .copyWith(fontSize: 12 * scale, color: SectionTheme.inkSoft)),
          SizedBox(height: 6 * scale),
          Text('8:15',
              style: SectionTheme.displayName(scale)
                  .copyWith(fontStyle: FontStyle.normal, fontSize: 30 * scale)),
          SizedBox(height: 10 * scale),

          // Chủ Nhật | 13 | Tháng 12
          _dateRow(),
          SizedBox(height: 6 * scale),
          Text('2026',
              style: SectionTheme.body(scale).copyWith(fontSize: 16 * scale)),
          SizedBox(height: 16 * scale),

          Text(
            '(T\u{1EE9}c ng\u{00E0}y 5 th\u{00E1}ng 11 n\u{0103}m B\u{00ED}nh Ng\u{1ECD})',
            textAlign: TextAlign.center,
            style: SectionTheme.body(scale)
                .copyWith(fontSize: 11 * scale, color: SectionTheme.inkMuted),
          ),
        ],
      ),
    );
  }

  Widget _family({required String side, required List<String> parents}) {
    return Column(
      children: [
        Text(side,
            style: SectionTheme.body(scale).copyWith(
              fontSize: 12 * scale,
              letterSpacing: 1 * scale,
              color: SectionTheme.inkSoft,
            )),
        SizedBox(height: 6 * scale),
        for (final p in parents)
          Padding(
            padding: EdgeInsets.only(bottom: 2 * scale),
            child: Text(p,
                textAlign: TextAlign.center,
                style: SectionTheme.body(scale).copyWith(fontSize: 13 * scale)),
          ),
      ],
    );
  }

  Widget _dateRow() {
    final divider = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * scale),
      child: Container(width: 1, height: 20 * scale, color: SectionTheme.hairline),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Ch\u{1EE7} Nh\u{1EAD}t',
            style: SectionTheme.body(scale).copyWith(fontSize: 14 * scale)),
        divider,
        Text('13',
            style: SectionTheme.displayName(scale)
                .copyWith(fontStyle: FontStyle.normal, fontSize: 22 * scale)),
        divider,
        Text('Th\u{00E1}ng 12',
            style: SectionTheme.body(scale).copyWith(fontSize: 14 * scale)),
      ],
    );
  }
}
