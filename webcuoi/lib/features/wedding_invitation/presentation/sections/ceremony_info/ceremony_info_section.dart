import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../section_theme.dart';

/// Wedding announcement and ceremony details over the supplied card artwork.
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
    final cardWidth = imageWidth * _cardWidthFraction;
    final nameStyle = TextStyle(
      fontFamily: SectionTheme.nameFontFamily,
      fontSize: (cardWidth * 0.11).clamp(32.0, 64.0),
      fontWeight: FontWeight.w400,
      color: SectionTheme.ink,
      height: 1.3,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      child: Center(
        child: SizedBox(
          width: cardWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -imageWidth * _cardLeftFraction,
                top: 0,
                bottom: 0,
                width: imageWidth,
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
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: cardWidth),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isCompact ? 18 : 28 * textScale,
                    isCompact ? 28 : 40 * textScale,
                    isCompact ? 18 : 28 * textScale,
                    isCompact ? 28 : 40 * textScale,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        header: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TRÂN TRỌNG BÁO TIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: SectionTheme.fontFamily,
                                fontSize: isCompact ? 12 : 14 * textScale,
                                fontWeight: FontWeight.w500,
                                color: SectionTheme.inkSoft,
                                height: 1.2,
                                letterSpacing: isCompact ? 1 : 1.5 * textScale,
                              ),
                            ),
                            SizedBox(height: isCompact ? 4 : 6 * textScale),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                isCompact
                                    ? 'LỄ CƯỚI\nCỦA CHÚNG TÔI'
                                    : 'LỄ CƯỚI CỦA CHÚNG TÔI',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: SectionTheme.fontFamily,
                                  fontSize: isCompact ? 18 : 24 * textScale,
                                  fontWeight: FontWeight.w600,
                                  color: SectionTheme.ink,
                                  height: 1.2,
                                  letterSpacing: 0.5 * textScale,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isCompact ? 18 : 28 * textScale,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Khắc Chính', style: nameStyle),
                            ),
                            SizedBox(height: 4 * textScale),
                            Text(
                              '&',
                              style: _smallStyle(
                                18,
                                textScale,
                              ).copyWith(height: 1.2),
                            ),
                            SizedBox(height: 4 * textScale),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Nguyễn Trang', style: nameStyle),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/ic_split.png',
                            width: isCompact ? 54 : 72 * textScale,
                            height: isCompact ? 16 : 24 * textScale,
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                          ),
                          SizedBox(height: isCompact ? 18 : 18 * textScale),
                          Text(
                            'LỄ CƯỚI ĐƯỢC CỬ HÀNH\nTẠI TƯ GIA',
                            textAlign: TextAlign.center,
                            style: _smallStyle(14, textScale).copyWith(
                              color: SectionTheme.ink,
                              fontSize: isCompact ? 12 : 18 * textScale,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              letterSpacing: 0.15 * textScale,
                            ),
                          ),
                          SizedBox(height: isCompact ? 10 : 14 * textScale),
                          Text('VÀO LÚC', style: _smallStyle(11, textScale)),
                          SizedBox(height: isCompact ? 4 : 6 * textScale),
                          Text(
                            '8:15',
                            style: TextStyle(
                              fontFamily: SectionTheme.fontFamily,
                              fontSize: isCompact ? 24 : 32 * textScale,
                              fontWeight: FontWeight.w500,
                              color: SectionTheme.ink,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: isCompact ? 12 : 14 * textScale),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
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
                                  style: _smallStyle(18, textScale).copyWith(
                                    fontFamily: SectionTheme.fontFamily,
                                    fontSize: isCompact ? 22 : 32 * textScale,
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                  ),
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
                          ),
                          SizedBox(height: isCompact ? 6 : 10 * textScale),
                          Text(
                            '2026',
                            style: _smallStyle(14, textScale).copyWith(
                              fontSize: isCompact ? 12 : 16 * textScale,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: isCompact ? 6 : 8 * textScale),
                          Text(
                            '(TỨC NGÀY 5 THÁNG 11 NĂM BÍNH NGỌ)',
                            textAlign: TextAlign.center,
                            style: _smallStyle(9, textScale).copyWith(
                              fontSize: isCompact ? 10 : 11 * textScale,
                              letterSpacing: isCompact ? 0.3 : 0.8 * textScale,
                              color: SectionTheme.inkSoft,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      fontWeight: isCompact ? FontWeight.w500 : null,
    );
  }
}
