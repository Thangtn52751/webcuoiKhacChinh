import 'package:flutter/material.dart';

import 'party_section_style.dart';
import 'party_time_column.dart';

class WeddingEventInformation extends StatelessWidget {
  const WeddingEventInformation({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final titleSize = isCompact ? 14.0 : 19 * scale;
    final headingSize = isCompact ? 15.0 : 25 * scale;
    final timeSize = isCompact ? 24.0 : 29 * scale;
    final dateLabelSize = isCompact ? 10.0 : 17 * scale;
    final daySize = isCompact ? 30.0 : 42 * scale;
    final yearSize = isCompact ? 18.0 : 25 * scale;
    final lunarSize = isCompact ? 9.0 : 12 * scale;
    double compactGap(double desktop, double mobile) {
      return isCompact ? mobile : desktop * scale;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'THÔNG TIN TIỆC CƯỚI',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            letterSpacing: isCompact ? 0.5 : 1.4 * scale,
            color: PartySectionStyle.primaryColor,
            height: 1.15,
          ),
        ),
        SizedBox(height: compactGap(18, 4)),
        Text(
          'TIỆC CƯỚI SẼ DIỄN RA VÀO LÚC:',
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: headingSize,
            height: 1.12,
            fontWeight: FontWeight.w500,
            letterSpacing: isCompact ? 0.1 : 0.6 * scale,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: compactGap(22, 4)),
        Text(
          '08:15',
          style: TextStyle(
            fontSize: timeSize,
            fontWeight: FontWeight.w500,
            height: 1,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: compactGap(14, 4)),
        _WeddingDateRow(
          scale: scale,
          isCompact: isCompact,
          labelSize: dateLabelSize,
          daySize: daySize,
        ),
        SizedBox(height: compactGap(16, 3)),
        Text(
          '2026',
          style: TextStyle(
            fontSize: yearSize,
            fontWeight: FontWeight.w500,
            color: PartySectionStyle.primaryColor,
          ),
        ),
        SizedBox(height: compactGap(8, 2)),
        Text(
          '(TỨC NGÀY 5 THÁNG 11 NĂM BÍNH NGỌ)',
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: lunarSize,
            height: 1.1,
            letterSpacing: isCompact ? 0.2 : 2.4 * scale,
            color: PartySectionStyle.accentColor,
          ),
        ),
        SizedBox(height: compactGap(22, 4)),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PartyTimeColumn(
              label: 'ĐÓN KHÁCH',
              time: '8:00',
              scale: isCompact ? 0.9 : scale,
            ),
            SizedBox(width: compactGap(46, 14)),
            PartyTimeColumn(
              label: 'KHAI TIỆC',
              time: '8:15',
              scale: isCompact ? 0.9 : scale,
            ),
          ],
        ),
      ],
    );
  }
}

class _WeddingDateRow extends StatelessWidget {
  const _WeddingDateRow({
    required this.scale,
    required this.isCompact,
    required this.labelSize,
    required this.daySize,
  });

  final double scale;
  final bool isCompact;
  final double labelSize;
  final double daySize;

  @override
  Widget build(BuildContext context) {
    final sideGap = isCompact ? 5.0 : 18 * scale;
    final dividerHeight = isCompact ? 20.0 : 24 * scale;
    final dividerMargin = isCompact ? 6.0 : 18 * scale;
    final textStyle = TextStyle(
      fontSize: labelSize,
      height: 1.1,
      fontWeight: FontWeight.w500,
      letterSpacing: isCompact ? 0 : 0.6 * scale,
      color: PartySectionStyle.primaryColor,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('CHỦ NHẬT', style: textStyle),
          SizedBox(width: sideGap),
          Container(
            height: dividerHeight,
            width: 1.2 * (isCompact ? 1 : scale),
            color: PartySectionStyle.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: dividerMargin),
          ),
          Text(
            '13',
            style: TextStyle(
              fontSize: daySize,
              height: 0.95,
              fontWeight: FontWeight.w600,
              color: PartySectionStyle.primaryColor,
            ),
          ),
          Container(
            height: dividerHeight,
            width: 1.2 * (isCompact ? 1 : scale),
            color: PartySectionStyle.primaryColor,
            margin: EdgeInsets.symmetric(horizontal: dividerMargin),
          ),
          SizedBox(width: sideGap),
          Text('THÁNG 12', style: textStyle),
        ],
      ),
    );
  }
}
