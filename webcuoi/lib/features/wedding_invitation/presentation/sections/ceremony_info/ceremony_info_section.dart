import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../section_theme.dart';

/// Family and ceremony details placed over the supplied info card artwork.
class CeremonyInfoSection extends StatelessWidget {
  const CeremonyInfoSection({super.key, required this.scale});

  final double scale;

  static const _artworkWidth = 743.0;
  static const _artworkHeight = 826.0;

  @override
  Widget build(BuildContext context) {
    final imageWidth = math.min(
      _artworkWidth * scale,
      MediaQuery.sizeOf(context).width * 0.98,
    );
    final imageHeight = imageWidth * _artworkHeight / _artworkWidth;
    final textScale = math.max(
      imageWidth / _artworkWidth,
      (scale * 0.9).clamp(0.65, 1.0),
    );
    final familyInset = imageWidth < 500 ? 0.25 : 0.3;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      child: Center(
        child: SizedBox(
          width: imageWidth,
          height: imageHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: imageWidth * 0.155,
                right: imageWidth * 0.10,
                top: imageHeight * 0.008,
                bottom: imageHeight * 0.008,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0x01FFFFFF),
                    borderRadius: BorderRadius.circular(15 * textScale),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x285A473B),
                        blurRadius: 20 * textScale,
                        offset: Offset(0, 8 * textScale),
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                'assets/images/decorations/info_Card1.png',
                fit: BoxFit.fill,
                excludeFromSemantics: true,
              ),
              _positionedText(
                imageWidth: imageWidth,
                imageHeight: imageHeight,
                top: 0.06,
                text: 'THÔNG TIN LỄ CƯỚI',
                fontSize: 17,
                weight: FontWeight.w600,
                letterSpacing: 0.5,
                scale: textScale,
              ),
              Positioned(
                top: imageHeight * 0.105,
                left: imageWidth * familyInset,
                right: imageWidth * familyInset,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _familyText(
                        'Nhà trai',
                        'Nguyễn Khắc Phúc\nNguyễn Thị Chang',
                        textScale,
                      ),
                    ),
                    Container(
                      width: 1.2 * textScale,
                      height: 56 * textScale,
                      margin: EdgeInsets.symmetric(horizontal: 10 * textScale),
                      color: SectionTheme.inkMuted.withValues(alpha: 0.65),
                    ),
                    Expanded(
                      child: _familyText('Nhà gái', 'Phạm Thị Lan', textScale),
                    ),
                  ],
                ),
              ),
              _positionedText(
                imageWidth: imageWidth,
                imageHeight: imageHeight,
                top: 0.24,
                text: 'TRÂN TRỌNG BÁO TIN\nLỄ THÀNH HÔN CỦA CON CHÚNG TÔI',
                fontSize: 12,
                lineHeight: 1.35,
                letterSpacing: 0.2,
                scale: textScale,
              ),
              _positionedText(
                imageWidth: imageWidth,
                imageHeight: imageHeight,
                top: 0.35,
                text: 'Nguyễn Khắc Chính',
                fontSize: 24,
                scale: textScale,
              ),
              _positionedText(
                imageWidth: imageWidth,
                imageHeight: imageHeight,
                top: 0.414,
                text: '&',
                fontSize: 18,
                scale: textScale,
              ),
              _positionedText(
                imageWidth: imageWidth,
                imageHeight: imageHeight,
                top: 0.468,
                text: 'Nguyễn Trang',
                fontSize: 24,
                scale: textScale,
              ),
              Positioned(
                top: imageHeight * 0.53,
                left: imageWidth * 0.08,
                right: imageWidth * 0.08,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'LỄ THÀNH HÔN ĐƯỢC CỬ HÀNH TẠI\nTƯ GIA',
                      textAlign: TextAlign.center,
                      style: _smallStyle(
                        20,
                        textScale,
                      ).copyWith(height: 1.35, letterSpacing: 0.15 * textScale),
                    ),
                    SizedBox(height: 18 * textScale),
                    Text('VÀO LÚC', style: _smallStyle(12, textScale)),
                    SizedBox(height: 8 * textScale),
                    Text('8:15', style: _smallStyle(20, textScale)),
                    SizedBox(height: 12 * textScale),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('CHỦ NHẬT', style: _smallStyle(11, textScale)),
                        SizedBox(width: 9 * textScale),
                        Text('|', style: _smallStyle(11, textScale)),
                        SizedBox(width: 9 * textScale),
                        Text(
                          '13',
                          style: _smallStyle(
                            18,
                            textScale,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 9 * textScale),
                        Text('|', style: _smallStyle(11, textScale)),
                        SizedBox(width: 9 * textScale),
                        Text('THÁNG 12', style: _smallStyle(11, textScale)),
                      ],
                    ),
                    SizedBox(height: 14 * textScale),
                    Text('2026', style: _smallStyle(14, textScale)),
                    SizedBox(height: 14 * textScale),
                    Text(
                      '(TỨC NGÀY 5 THÁNG 11 NĂM BÍNH NGỌ)',
                      textAlign: TextAlign.center,
                      style: _smallStyle(
                        9,
                        textScale,
                      ).copyWith(letterSpacing: 0.9 * textScale),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _familyText(String heading, String names, double scale) => Column(
    children: [
      Text(heading, textAlign: TextAlign.center, style: _smallStyle(10, scale)),
      SizedBox(height: 3 * scale),
      Text(
        names,
        textAlign: TextAlign.center,
        style: _smallStyle(
          10,
          scale,
        ).copyWith(fontWeight: FontWeight.w600, height: 1.35),
      ),
    ],
  );

  Positioned _positionedText({
    required double imageWidth,
    required double imageHeight,
    required double top,
    required String text,
    required double fontSize,
    required double scale,
    FontWeight weight = FontWeight.w400,
    double lineHeight = 1.2,
    double letterSpacing = 0,
  }) => Positioned(
    top: imageHeight * top,
    left: imageWidth * 0.12,
    right: imageWidth * 0.12,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: _smallStyle(fontSize, scale).copyWith(
        fontWeight: weight,
        height: lineHeight,
        letterSpacing: letterSpacing * scale,
      ),
    ),
  );

  TextStyle _smallStyle(double fontSize, double scale) => TextStyle(
    color: SectionTheme.inkSoft,
    fontFamily: SectionTheme.fontFamily,
    fontSize: fontSize * scale * 1.25,
  );
}
