import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/pages/wedding_cover_page.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/ceremony_info/ceremony_info_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/wedding_party_section.dart';
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
