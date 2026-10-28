import 'package:flutter/material.dart';

import '../section_theme.dart';

/// Section 1 — phần mở đầu trang nội dung thiệp (theo Figma):
/// "THE WEDDING OF" + tên cặp đôi (serif nghiêng) + ảnh cưới polaroid
/// (ảnh đã gồm sẵn khung nghiêng, washi tape, hoa khô và con dấu sáp).
class CoverHeaderSection extends StatelessWidget {
  const CoverHeaderSection({
    super.key,
    required this.scale,
    this.overline = 'THE WEDDING OF',
    this.coupleNames = 'Kh\u{1EAF}c Ch\u{00ED}nh & Th\u{1ECB} Trang',
  });

  final double scale;
  final String overline;
  final String coupleNames;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40 * scale, bottom: 24 * scale),
      child: Column(
        children: [
          Text(
            overline.toUpperCase(),
            textAlign: TextAlign.center,
            style: SectionTheme.overline(scale),
          ),
          SizedBox(height: 14 * scale),
          Text(
            coupleNames,
            textAlign: TextAlign.center,
            style: SectionTheme.displayName(scale),
          ),
          SizedBox(height: 28 * scale),
          // Ảnh cưới polaroid (đã gồm khung, hoa khô, con dấu sáp trong ảnh).
          Image.asset(
            'assets/images/decorations/hero_couple_photo.png',
            width: 360 * scale,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
