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
                fontSize: 13 * s,
                fontStyle: FontStyle.italic,
                color: PartySectionStyle.primaryColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 14 * s),
        SizedBox(
          height: 36 * s,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: PartySectionStyle.calendarBgColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 30 * s),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'XÁC NHẬN THAM DỰ',
              style: TextStyle(
                fontFamily: PartySectionStyle.serifFont,
                fontFamilyFallback: PartySectionStyle.serifFallback,
                fontSize: 11.5 * s,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4 * s,
                color: const Color(0xFFF3EFEA),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
