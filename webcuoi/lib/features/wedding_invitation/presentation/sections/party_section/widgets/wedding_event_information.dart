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
            fontSize: 19 * s,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4 * s,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 18 * s),
        Text(
          'TIỆC CƯỚI SẼ DIỄN RA VÀO LÚC:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25 * s,
            fontWeight: DefaultTextStyle.of(context).style.fontWeight,
            letterSpacing: 0.6 * s,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 24 * s),

        // --- GIỜ & NGÀY THÁNG NĂM ---
        Text(
          '08:15',
          style: TextStyle(
            fontSize: 29 * s,
            fontWeight: DefaultTextStyle.of(context).style.fontWeight,
            height: 1.0,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 16 * s),

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
                  fontSize: 17 * s,
                  fontWeight: DefaultTextStyle.of(context).style.fontWeight,
                  letterSpacing: 0.6 * s,
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
                fontSize: 42 * s,
                fontWeight: DefaultTextStyle.of(context).style.fontWeight,
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
                  fontSize: 17 * s,
                  fontWeight: DefaultTextStyle.of(context).style.fontWeight,
                  letterSpacing: 0.6 * s,
                  color: PartySectionStyle.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16 * s),
        Text(
          '2026',
          style: TextStyle(
            fontSize: 25 * s,
            fontWeight: DefaultTextStyle.of(context).style.fontWeight,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: 10 * s),
        Text(
          '(TỨC NGÀY 5 THÁNG 11 NĂM BÍNH NGỌ)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12 * s,
            fontWeight: DefaultTextStyle.of(context).style.fontWeight,
            letterSpacing: 2.4 * s,
            color: PartySectionStyle.accentColor,
          ),
        ),
        SizedBox(height: 24 * s),

        // --- ĐÓN KHÁCH & KHAI TIỆC ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PartyTimeColumn(label: 'ĐÓN KHÁCH', time: '8:00', scale: s),
            SizedBox(width: 46 * s),
            PartyTimeColumn(label: 'KHAI TIỆC', time: '8:15', scale: s),
          ],
        ),
        SizedBox(height: 24 * s),
      ],
    );
  }
}
