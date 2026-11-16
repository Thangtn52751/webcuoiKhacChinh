import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/ceremony_info/ceremony_info_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/section_theme.dart';

void main() {
  testWidgets('large ceremony names fit between the announcement and details', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await (FontLoader(
      SectionTheme.nameFontFamily,
    )..addFont(rootBundle.load('assets/fonts/Ephesis-Regular.ttf'))).load();

    for (final width in [320.0, 375.0, 390.0, 430.0, 768.0, 1440.0]) {
      final canvasWidth = math.min(width, 900.0);
      final scale = (canvasWidth / 900).clamp(0.72, 1.0);
      for (final textScale in [1.0, 1.3]) {
        tester.view.physicalSize = Size(width, 1400);
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(textScale)),
              child: child!,
            ),
            home: Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: canvasWidth,
                    child: CeremonyInfoSection(scale: scale),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final contextLabel = '$width px, text scale $textScale';
        expect(tester.takeException(), isNull, reason: contextLabel);

        final groomFinder = find.text('Khắc Chính');
        final brideFinder = find.text('Nguyễn Trang');
        final groom = tester.getRect(groomFinder);
        final bride = tester.getRect(brideFinder);
        final ampersand = tester.getRect(find.text('&'));
        final overline = tester.getRect(find.text('TRÂN TRỌNG BÁO TIN'));
        final announcement = tester.getRect(
          find.textContaining(RegExp(r'^LỄ CƯỚI\s+CỦA CHÚNG TÔI$')),
        );
        final venue = tester.getRect(
          find.textContaining(RegExp(r'^LỄ CƯỚI ĐƯỢC CỬ HÀNH\s+TẠI\s+TƯ GIA$')),
        );
        final divider = tester.getRect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                widget.image is AssetImage &&
                (widget.image as AssetImage).assetName.endsWith('ic_split.png'),
          ),
        );
        final lunar = tester.getRect(find.textContaining('(TỨC NGÀY'));
        final artwork = tester.getRect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                widget.image is AssetImage &&
                (widget.image as AssetImage).assetName.endsWith(
                  'info_Card1.png',
                ),
          ),
        );
        final cardLeft = artwork.left + artwork.width * 118 / 627;
        final cardRight = artwork.left + artwork.width * 614 / 627;
        expect(
          overline.top - artwork.top,
          inInclusiveRange(20, 50),
          reason: 'The heading stays near the card top: $contextLabel',
        );
        expect(
          announcement.center.dx,
          closeTo((cardLeft + cardRight) / 2, 0.1),
          reason: contextLabel,
        );
        final otherTextSizes = tester
            .widgetList<Text>(find.byType(Text))
            .where(
              (text) =>
                  text.data != 'Khắc Chính' && text.data != 'Nguyễn Trang',
            )
            .map((text) => text.style?.fontSize ?? 0);
        final largestOtherSize = otherTextSizes.reduce(math.max);

        for (final nameFinder in [groomFinder, brideFinder]) {
          final text = tester.widget<Text>(nameFinder);
          final style = text.style!;
          expect(style.fontFamily, SectionTheme.nameFontFamily);
          expect(
            style.fontSize,
            greaterThan(largestOtherSize),
            reason: contextLabel,
          );
          final name = tester.getRect(nameFinder);
          expect(
            name.left,
            greaterThanOrEqualTo(cardLeft),
            reason: contextLabel,
          );
          expect(
            name.right,
            lessThanOrEqualTo(cardRight),
            reason: contextLabel,
          );
          expect(
            name.center.dx,
            closeTo((cardLeft + cardRight) / 2, 0.1),
            reason: contextLabel,
          );
          final painter = TextPainter(
            text: TextSpan(text: text.data, style: style),
            textDirection: TextDirection.ltr,
            textScaler: TextScaler.linear(textScale),
          )..layout(maxWidth: tester.getSize(nameFinder).width);
          expect(
            painter.computeLineMetrics(),
            hasLength(1),
            reason: contextLabel,
          );
          painter.dispose();
        }

        expect(
          announcement.bottom,
          lessThanOrEqualTo(groom.top),
          reason: contextLabel,
        );
        expect(
          groom.top - announcement.bottom,
          lessThanOrEqualTo(40),
          reason: 'Keep the heading and names together: $contextLabel',
        );
        expect(groom.bottom, lessThan(ampersand.top), reason: contextLabel);
        expect(ampersand.bottom, lessThan(bride.top), reason: contextLabel);
        expect(
          divider.top - bride.bottom,
          inInclusiveRange(0, 28),
          reason: 'Keep the ornament close to the names: $contextLabel',
        );
        expect(
          venue.top - bride.bottom,
          greaterThanOrEqualTo(16),
          reason: contextLabel,
        );
        expect(
          lunar.bottom,
          lessThan(artwork.bottom - 12),
          reason: contextLabel,
        );
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }
  });
}
