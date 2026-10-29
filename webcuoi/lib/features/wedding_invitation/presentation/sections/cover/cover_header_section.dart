import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../section_theme.dart';

class CoverHeaderSection extends StatelessWidget {
  const CoverHeaderSection({
    super.key,
    required this.scale,
    this.overline = 'THE WEDDING OF',
    this.coupleNames = 'Khắc Chính & Thị Trang',
  });

  final double scale;
  final String overline;
  final String coupleNames;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final singleLineNames = coupleNames.replaceAll(RegExp(r'\s*&\s*'), ' & ');
    final responsiveNames = screenWidth < 640
        ? singleLineNames.replaceFirst(' & ', '\n& ')
        : singleLineNames;

    return Padding(
      padding: EdgeInsets.only(top: 48 * scale, bottom: 38 * scale),
      child: Column(
        children: [
          Text(
            overline.toUpperCase(),
            textAlign: TextAlign.center,
            style: SectionTheme.overline(scale)
                .copyWith(fontSize: 14 * scale, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 14 * scale),
          Text(
            responsiveNames,
            textAlign: TextAlign.center,
            style: SectionTheme.displayName(scale).copyWith(
              color: SectionTheme.inkSoft,
              fontFamily: 'CormorantGaramond',
              fontSize: 42 * scale,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.15 * scale,
              height: 1.05,
            ),
          ),
          SizedBox(height: 24 * scale),
          Image.asset(
            'assets/images/decorations/intro_pic.png',
            width: math.min(
              450 * scale,
              MediaQuery.sizeOf(context).width * 0.56,
            ),
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ],
      ),
    );
  }
}
