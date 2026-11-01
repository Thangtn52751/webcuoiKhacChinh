import 'package:flutter/material.dart';

import 'party_section_style.dart';

class WeddingPageIndicator extends StatelessWidget {
  const WeddingPageIndicator({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      '1 / 8',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: PartySectionStyle.serifFont,
        fontFamilyFallback: PartySectionStyle.serifFallback,
        color: PartySectionStyle.accentColor,
        fontSize: 9 * scale,
        letterSpacing: 0.4 * scale,
      ),
    );
  }
}
