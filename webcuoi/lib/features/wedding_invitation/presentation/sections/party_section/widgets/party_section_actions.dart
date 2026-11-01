import 'package:flutter/material.dart';

import 'party_section_style.dart';

class PartySectionActions extends StatelessWidget {
  const PartySectionActions({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- THÊM VÀO LỊCH & NÚT XÁC NHẬN THAM DỰ ---
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(bottom: 2 * s),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: PartySectionStyle.primaryColor,
                  width: 1 * s,
                ),
              ),
            ),
            child: Text(
              'Thêm vào lịch',
              style: TextStyle(
                fontFamily: PartySectionStyle.serifFont,
                fontFamilyFallback: PartySectionStyle.serifFallback,
                fontSize: 14 * s,
                fontStyle: FontStyle.italic,
                color: PartySectionStyle.primaryColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 16 * s),
        SizedBox(
          height: 32 * s,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: PartySectionStyle.calendarBgColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 26 * s),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'XÁC NHẬN THAM DỰ',
              style: TextStyle(
                fontFamily: PartySectionStyle.serifFont,
                fontFamilyFallback: PartySectionStyle.serifFallback,
                fontSize: 12.5 * s,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0 * s,
                color: const Color(0xFFF3EFEA),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
