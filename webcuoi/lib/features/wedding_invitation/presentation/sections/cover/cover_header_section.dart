import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../section_theme.dart';

class CoverHeaderSection extends StatelessWidget {
  const CoverHeaderSection({
    super.key,
    required this.scale,
    this.overline = 'THE WEDDING OF',
    this.coupleNames = 'Khắc Chính & Nguyễn Trang',
  });

  final double scale;
  final String overline;
  final String coupleNames;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.widthOf(context);
    final photoWidth = math.min(450 * scale, screenWidth * 0.56);
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
            style: SectionTheme.overline(scale).copyWith(
              fontFamily: SectionTheme.fontFamilyFor(context),
              fontSize: 14 * scale,
              fontWeight: SectionTheme.weightFor(context, FontWeight.w400),
            ),
          ),
          SizedBox(height: 14 * scale),
          Text(
            responsiveNames,
            textAlign: TextAlign.center,
            style: SectionTheme.displayName(scale).copyWith(
              color: SectionTheme.inkSoft,
              fontFamily: SectionTheme.fontFamilyFor(context),
              fontSize: 42 * scale,
              fontStyle: FontStyle.italic,
              fontWeight: SectionTheme.isCompact(context)
                  ? FontWeight.w500
                  : FontWeight.w600,
              letterSpacing: 0.15 * scale,
              height: 1.05,
            ),
          ),
          SizedBox(height: 24 * scale),
          Image.asset(
            'assets/images/decorations/intro_pic.png',
            width: photoWidth,
            height: photoWidth * 829 / 553,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
        ],
      ),
    );
  }
}
