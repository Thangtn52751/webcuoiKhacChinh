import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/pages/wedding_cover_page.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/ceremony_info/ceremony_info_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/wedding_party_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/widgets/party_section_actions.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/widgets/wedding_calendar_card.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/widgets/wedding_event_information.dart';
import 'package:webcuoi/main.dart';

void main() {
  testWidgets('app starts on the wedding cover without loading audio first', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(WeddingCoverPage), findsOneWidget);
    expect(find.text('Mở thiệp'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('ceremony and party sections fit common mobile widths', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;

    for (final width in [
      320.0,
      360.0,
      375.0,
      390.0,
      393.0,
      414.0,
      430.0,
      768.0,
      1024.0,
      1440.0,
    ]) {
      tester.view.physicalSize = Size(width, 1000);
      final scale = width < 600 ? 0.72 : 1.0;
      await _expectNoOverflow(tester, CeremonyInfoSection(scale: scale), width);
      await _expectNoOverflow(tester, WeddingPartySection(scale: scale), width);
    }

    await tester.pumpWidget(const SizedBox.shrink());
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  testWidgets(
    'mobile party keeps its information, calendar and actions together',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final width in [320.0, 375.0, 390.0, 414.0, 430.0]) {
        for (final textScale in [1.0, 1.3]) {
          tester.view.physicalSize = Size(width, 1200);
          await tester.pumpWidget(
            MaterialApp(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(textScale)),
                child: child!,
              ),
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: WeddingPartySection(scale: 0.72),
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
          expect(
            calendar.top - information.bottom,
            inInclusiveRange(16.0, 28.0),
            reason: 'No large empty gap before the calendar: $contextLabel',
          );
          expect(
            calendar.height / calendar.width,
            greaterThanOrEqualTo(0.65),
            reason: 'Calendar cells must remain readable: $contextLabel',
          );
          expect(
            actions.top - calendar.bottom,
            inInclusiveRange(8.0, 16.0),
            reason: 'Actions must stay next to the calendar: $contextLabel',
          );
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
          expect(
            actions.bottom,
            lessThan(artwork.bottom - artwork.height * 68 / 1077),
            reason: 'Both actions must be inside the card: $contextLabel',
          );
        }
      }
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}

Future<void> _expectNoOverflow(
  WidgetTester tester,
  Widget section,
  double width,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: Center(child: section)),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final exception = tester.takeException();
  expect(
    exception,
    isNull,
    reason: 'Layout overflow in ${section.runtimeType} at $width px',
  );
}
