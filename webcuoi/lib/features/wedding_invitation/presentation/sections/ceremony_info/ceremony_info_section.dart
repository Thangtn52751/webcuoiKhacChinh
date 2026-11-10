import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../section_theme.dart';

/// Family and ceremony details placed over the supplied info card artwork.
class CeremonyInfoSection extends StatelessWidget {
  const CeremonyInfoSection({super.key, required this.scale});

  final double scale;

  static const _artworkWidth = 743.0;
  static const _artworkHeight = 826.0;
  // The card surface in info_Card1.png spans x=118..614 of its 627px width.
  // Center that surface as the layout box and let the flower extend outside it.
  static const _cardLeftFraction = 118 / 627;
  static const _cardWidthFraction = (614 - 118) / 627;

  @override
  Widget build(BuildContext context) {
    final imageWidth = math.min(
      _artworkWidth * scale,
      MediaQuery.widthOf(context) * 0.98,
    );
    final imageHeight = imageWidth * _artworkHeight / _artworkWidth;
    final isCompact = imageWidth < 500;
    final textScale = math.max(
      imageWidth / _artworkWidth,
      isCompact ? 0.62 : (scale * 0.9).clamp(0.65, 1.0),
    );
    final familyGroupWidth = imageWidth * (isCompact ? 0.32 : 0.24);
    final familyDividerGap = isCompact ? 8.0 : 12 * textScale;
    final cardWidth = imageWidth * _cardWidthFraction;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      child: Center(
        child: SizedBox(
          width: cardWidth,
          height: imageHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -imageWidth * _cardLeftFraction,
                top: 0,
                width: imageWidth,
                height: imageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: imageWidth * 0.157,
                      right: imageWidth * 0.083,
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
                      weight: FontWeight.w700,
                      color: SectionTheme.ink,
                      letterSpacing: 0.5,
                      scale: textScale,
                    ),
                    Positioned(
                      top: imageHeight * 0.105,
                      left: imageWidth * _cardLeftFraction,
                      right:
                          imageWidth *
                          (1 - _cardLeftFraction - _cardWidthFraction),
                      child: Center(
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: familyGroupWidth,
                                child: _familyText(
                                  'Nhà trai',
                                  'Nguyễn Khắc Phác\nNguyễn Thị Chung',
                                  textScale,
                                  nameAlignment: TextAlign.right,
                                ),
                              ),
                              SizedBox(width: familyDividerGap),
                              VerticalDivider(
                                width: 1.2 * textScale,
                                thickness: 1.2 * textScale,
                                color: SectionTheme.inkMuted.withValues(
                                  alpha: 0.65,
                                ),
                              ),
                              SizedBox(width: familyDividerGap),
                              SizedBox(
                                width: familyGroupWidth,
                                child: _familyText(
                                  'Nhà gái',
                                  'Vũ Thị Khoa',
                                  textScale,
                                  nameAlignment: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _positionedText(
                      imageWidth: imageWidth,
                      imageHeight: imageHeight,
                      top: 0.24,
                      text:
                          'TRÂN TRỌNG BÁO TIN\nLỄ THÀNH HÔN CỦA CON CHÚNG TÔI',
                      fontSize: 12,
                      weight: FontWeight.w600,
                      color: SectionTheme.ink,
                      lineHeight: 1.35,
                      letterSpacing: 0.2,
                      scale: textScale,
                    ),
                    _positionedText(
                      imageWidth: imageWidth,
                      imageHeight: imageHeight,
                      top: 0.35,
                      text: 'Khắc Chính',
                      fontSize: isCompact ? 27 : 24,
                      weight: FontWeight.w700,
                      color: SectionTheme.ink,
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
                      fontSize: isCompact ? 27 : 24,
                      weight: FontWeight.w700,
                      color: SectionTheme.ink,
                      scale: textScale,
                    ),
                    Positioned(
                      top: imageHeight * 0.53 + (isCompact ? 20 : 0),
                      left: imageWidth * 0.157,
                      right: imageWidth * 0.003,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'LỄ CƯỚI ĐƯỢC CỬ HÀNH TẠI TƯ GIA',
                            textAlign: TextAlign.center,
                            style: _smallStyle(20, textScale).copyWith(
                              color: SectionTheme.ink,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                              letterSpacing: 0.15 * textScale,
                            ),
                          ),
                          SizedBox(height: (isCompact ? 8 : 18) * textScale),
                          Text('VÀO LÚC', style: _smallStyle(12, textScale)),
                          SizedBox(height: (isCompact ? 10 : 8) * textScale),
                          Text('8:15', style: _smallStyle(20, textScale)),
                          SizedBox(height: (isCompact ? 10 : 12) * textScale),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'CHỦ NHẬT',
                                style: _smallStyle(11, textScale),
                              ),
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
                              Text(
                                'THÁNG 12',
                                style: _smallStyle(11, textScale),
                              ),
                            ],
                          ),
                          SizedBox(height: (isCompact ? 10 : 14) * textScale),
                          Text('2026', style: _smallStyle(14, textScale)),
                          SizedBox(height: (isCompact ? 10 : 14) * textScale),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _familyText(
    String heading,
    String names,
    double scale, {
    required TextAlign nameAlignment,
  }) => Align(
    alignment: nameAlignment == TextAlign.right
        ? Alignment.topRight
        : Alignment.topLeft,
    child: IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: _smallStyle(
              10,
              scale,
            ).copyWith(color: SectionTheme.ink, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 3 * scale),
          Text(
            names,
            textAlign: nameAlignment,
            style: _smallStyle(10, scale).copyWith(
              color: SectionTheme.ink,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    ),
  );

  Positioned _positionedText({
    required double imageWidth,
    required double imageHeight,
    required double top,
    required String text,
    required double fontSize,
    required double scale,
    FontWeight? weight,
    Color? color,
    double lineHeight = 1.2,
    double letterSpacing = 0,
  }) => Positioned(
    top: imageHeight * top,
    left: imageWidth * 0.197,
    right: imageWidth * 0.043,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: _smallStyle(fontSize, scale).copyWith(
        color: color,
        fontWeight: weight,
        height: lineHeight,
        letterSpacing: letterSpacing * scale,
      ),
    ),
  );

  TextStyle _smallStyle(double fontSize, double scale) {
    final isCompact = scale < 0.8;
    var resolvedFontSize = fontSize * scale * (isCompact ? 1 : 1.25);
    if (isCompact) {
      final minimumFontSize = fontSize <= 9
          ? 8.5
          : fontSize <= 10
          ? 9.5
          : fontSize <= 12
          ? 10.5
          : fontSize <= 14
          ? 11.5
          : fontSize <= 18
          ? 12.0
          : resolvedFontSize;
      resolvedFontSize = math.max(resolvedFontSize, minimumFontSize);
    }

    return TextStyle(
      color: isCompact ? SectionTheme.ink : SectionTheme.inkSoft,
      fontFamily: isCompact ? SectionTheme.mobileFontFamily : null,
      fontSize: resolvedFontSize,
      fontWeight: isCompact ? FontWeight.w600 : null,
    );
  }
}
