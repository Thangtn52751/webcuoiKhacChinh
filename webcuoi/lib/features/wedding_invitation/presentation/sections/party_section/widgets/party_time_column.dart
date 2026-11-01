import 'package:flutter/material.dart';

import 'party_section_style.dart';

class PartyTimeColumn extends StatelessWidget {
  const PartyTimeColumn({
    super.key,
    required this.label,
    required this.time,
    required this.scale,
  });

  final String label;
  final String time;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: PartySectionStyle.serifFont,
            fontFamilyFallback: PartySectionStyle.serifFallback,
            fontSize: 10.5 * scale,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0 * scale,
            color: PartySectionStyle.accentColor,
          ),
        ),
        SizedBox(height: 5 * scale),
        Text(
          time,
          style: TextStyle(
            fontFamily: PartySectionStyle.serifFont,
            fontFamilyFallback: PartySectionStyle.serifFallback,
            fontSize: 18 * scale,
            fontWeight: FontWeight.w500,
            color: PartySectionStyle.primaryColor,
          ),
        ),
      ],
    );
  }
}
