import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/wedding_party_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/widgets/party_section_actions.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/widgets/wedding_calendar_card.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/widgets/wedding_event_information.dart';

void main() {
  testWidgets(
    'desktop party keeps a readable calendar and both actions inside its card',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final width in [768.0, 1024.0, 1440.0, 1920.0]) {
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
                      child: WeddingPartySection(scale: scale),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final contextLabel = '$width px, text scale $textScale';
          expect(tester.takeException(), isNull, reason: contextLabel);

          final information = tester.getRect(
            find.byType(WeddingEventInformation),
          );
          final calendar = tester.getRect(find.byType(WeddingCalendarCard));
          final actions = tester.getRect(find.byType(PartySectionActions));
          final artwork = tester.getRect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Image &&
                  widget.image is AssetImage &&
                  (widget.image as AssetImage).assetName.endsWith(
                    'Group_5.png',
                  ),
            ),
          );
          final card = Rect.fromLTRB(
            artwork.left + artwork.width * 0.2288,
            artwork.top + artwork.height * 65 / 1077,
            artwork.right - artwork.width * 0.1492,
            artwork.bottom - artwork.height * 68 / 1077,
          );

          expect(
            calendar.top - information.bottom,
            inInclusiveRange(16 * scale, 32 * scale),
            reason: 'No large empty gap before the calendar: $contextLabel',
          );
          expect(
            calendar.width / card.width,
            greaterThanOrEqualTo(0.60),
            reason:
                'The calendar must fill a readable portion of the card: $contextLabel',
          );
          expect(
            actions.top - calendar.bottom,
            inInclusiveRange(8 * scale, 20 * scale),
            reason: 'Keep both actions close to the calendar: $contextLabel',
          );
          expect(
            calendar.center.dx,
            closeTo(card.center.dx, 0.1),
            reason: contextLabel,
          );
          expect(
            actions.center.dx,
            closeTo(card.center.dx, 0.1),
            reason: contextLabel,
          );
          expect(card.center.dx, closeTo(width / 2, 0.1), reason: contextLabel);
          expect(information.top, greaterThan(card.top), reason: contextLabel);
          expect(
            actions.bottom,
            lessThan(card.bottom - 8 * scale),
            reason: contextLabel,
          );
          expect(calendar.left, greaterThan(card.left), reason: contextLabel);
          expect(calendar.right, lessThan(card.right), reason: contextLabel);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    },
  );
}
