import 'package:flutter/material.dart';

import 'party_section_style.dart';
import 'party_time_column.dart';

class WeddingEventInformation extends StatelessWidget {
  const WeddingEventInformation({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --- TIÊU ĐỀ ---
        Text(
          'THÔNG TIN TIỆC CƯỚI',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: PartySectionStyle.serifFont,
            fontFamilyFallback: PartySectionStyle.serifFallback,
            fontSize: 15 * s,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5 * s,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 12 * s),
        Text(
          'TIỆC CƯỚI SẼ DIỄN RA VÀO LÚC:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: PartySectionStyle.serifFont,
            fontFamilyFallback: PartySectionStyle.serifFallback,
            fontSize: 19 * s,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0 * s,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 22 * s),

        // --- GIỜ & NGÀY THÁNG NĂM ---
        Text(
          '08:15',
          style: TextStyle(
            fontFamily: PartySectionStyle.serifFont,
            fontFamilyFallback: PartySectionStyle.serifFallback,
            fontSize: 27 * s,
            fontWeight: FontWeight.w400,
            height: 1.0,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 14 * s),

        // Hàng CHỦ NHẬT | 13 | THÁNG 12 cân xứng 2 bên số 13
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'CHỦ NHẬT',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: PartySectionStyle.serifFont,
                  fontFamilyFallback: PartySectionStyle.serifFallback,
                  fontSize: 13 * s,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2 * s,
                  color: PartySectionStyle.primaryColor,
                ),
              ),
            ),
            Container(
              height: 24 * s,
              width: 1.2 * s,
              color: PartySectionStyle.primaryColor,
              margin: EdgeInsets.symmetric(horizontal: 18 * s),
            ),
            Text(
              '13',
              style: TextStyle(
                fontFamily: PartySectionStyle.serifFont,
                fontFamilyFallback: PartySectionStyle.serifFallback,
                fontSize: 38 * s,
                fontWeight: FontWeight.w500,
                height: 0.95,
                color: PartySectionStyle.primaryColor,
              ),
            ),
            Container(
              height: 24 * s,
              width: 1.2 * s,
              color: PartySectionStyle.primaryColor,
              margin: EdgeInsets.symmetric(horizontal: 18 * s),
            ),
            Expanded(
              child: Text(
                'THÁNG 12',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: PartySectionStyle.serifFont,
                  fontFamilyFallback: PartySectionStyle.serifFallback,
                  fontSize: 13 * s,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2 * s,
                  color: PartySectionStyle.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14 * s),
        Text(
          '2026',
          style: TextStyle(
            fontFamily: PartySectionStyle.serifFont,
            fontFamilyFallback: PartySectionStyle.serifFallback,
            fontSize: 21 * s,
            fontWeight: FontWeight.w400,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 10 * s),
        Text(
          '(TỨC NGÀY 5 THÁNG 11 NĂM BÍNH NGỌ)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: PartySectionStyle.serifFont,
            fontFamilyFallback: PartySectionStyle.serifFallback,
            fontSize: 10.5 * s,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.8 * s,
            color: PartySectionStyle.accentColor,
          ),
        ),
        SizedBox(height: 24 * s),

        // --- ĐÓN KHÁCH & KHAI TIỆC ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PartyTimeColumn(label: 'ĐÓN KHÁCH', time: '8:00', scale: s),
            SizedBox(width: 52 * s),
            PartyTimeColumn(label: 'KHAI TIỆC', time: '8:15', scale: s),
          ],
        ),
        SizedBox(height: 24 * s),
      ],
    );
  }
}
