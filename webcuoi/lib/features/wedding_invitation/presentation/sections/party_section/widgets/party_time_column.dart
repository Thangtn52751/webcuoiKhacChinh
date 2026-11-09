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
            fontSize: 12 * scale,
            fontWeight: DefaultTextStyle.of(context).style.fontWeight,
            letterSpacing: 0.7 * scale,
            color: PartySectionStyle.accentColor,
          ),
        ),
        SizedBox(height: 5 * scale),
        Text(
          time,
          style: TextStyle(
            fontSize: 21 * scale,
            fontWeight: DefaultTextStyle.of(context).style.fontWeight,
            color: PartySectionStyle.primaryColor,
          ),
        ),
      ],
    );
  }
}
