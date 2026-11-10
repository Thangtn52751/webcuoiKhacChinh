import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/gift_box/gift_box_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/widgets/invitation_scroll_view.dart';

const _mainGift = 'assets/images/decorations/big_Present.png';

void main() {
  testWidgets('gift animates in view and stops during scroll and offscreen', (
    tester,
  ) async {
    final controller = await _pumpGift(tester);
    expect(_imageAt(_mainGift), findsNothing);
    expect(tester.binding.hasScheduledFrame, isFalse);

    controller.jumpTo(1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(_imageAt(_mainGift), findsOneWidget);
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pump(const Duration(milliseconds: 800));
    final initialPosition = tester.getRect(_imageAt(_mainGift));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      tester.getRect(_imageAt(_mainGift)).top,
      isNot(closeTo(initialPosition.top, 0.1)),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(_imageAt(_mainGift)),
    );
    await gesture.moveBy(const Offset(0, -50));
    await tester.pump();
    expect(controller.position.isScrollingNotifier.value, isTrue);
    final heldPosition = tester.getRect(_imageAt(_mainGift));
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.getRect(_imageAt(_mainGift)), heldPosition);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await gesture.up();
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isTrue);

    controller.jumpTo(2200);
    await tester.pumpAndSettle();
    expect(_imageAt(_mainGift), findsNothing);
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pump(const Duration(seconds: 2));
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'both gift triggers open QR details and pause the idle underlay',
    (tester) async {
      final controller = await _pumpGift(tester);
      await _revealGift(tester, controller);

      for (final trigger in [_imageAt(_mainGift), find.text('Nhấn để mở')]) {
        await tester.tap(trigger.hitTestable());
        await tester.pumpAndSettle();
        expect(find.byType(Dialog), findsOneWidget);
        expect(_imageAt('assets/images/gallery/qr_hus.jpeg'), findsOneWidget);
        expect(_imageAt('assets/images/gallery/qr_Wife.jpeg'), findsOneWidget);
        expect(find.text('Nguyễn Khắc Chính'), findsOneWidget);
        expect(find.text('Nguyễn Trang'), findsOneWidget);
        expect(tester.binding.hasScheduledFrame, isFalse);
        final frozenPosition = tester.getRect(_imageAt(_mainGift));
        await tester.pump(const Duration(seconds: 2));
        expect(tester.getRect(_imageAt(_mainGift)), frozenPosition);
        expect(tester.binding.hasScheduledFrame, isFalse);

        await tester.tap(find.byTooltip('Đóng'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump();
        expect(find.byType(Dialog), findsNothing);
        expect(tester.binding.hasScheduledFrame, isTrue);
        final resumedPosition = tester.getRect(_imageAt(_mainGift));
        await tester.pump(const Duration(milliseconds: 600));
        expect(
          tester.getRect(_imageAt(_mainGift)).top,
          isNot(closeTo(resumedPosition.top, 0.1)),
        );
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('reduced motion shows the gift without a continuous frame loop', (
    tester,
  ) async {
    final controller = await _pumpGift(tester, reducedMotion: true);
    controller.jumpTo(1000);
    await tester.pumpAndSettle();
    expect(_imageAt(_mainGift), findsOneWidget);
    expect(tester.binding.hasScheduledFrame, isFalse);
    final position = tester.getRect(_imageAt(_mainGift));
    await tester.pump(const Duration(seconds: 2));
    expect(tester.getRect(_imageAt(_mainGift)), position);
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Finder _imageAt(String path) => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName == path,
  skipOffstage: false,
);

Future<ScrollController> _pumpGift(
  WidgetTester tester, {
  bool reducedMotion = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 800);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final controller = ScrollController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
        child: child!,
      ),
      home: Scaffold(
        body: InvitationScrollView(
          controller: controller,
          viewportWidth: 390,
          canvasWidth: 390,
          backgroundAsset: 'assets/images/backgrounds/mainBG.mobile.webp',
          children: const [
            SizedBox(height: 1000),
            GiftBoxSection(scale: 0.72),
            SizedBox(height: 1600),
          ],
        ),
      ),
    ),
  );
  await tester.runAsync(() async {
    final context = tester.element(
      find.byType(GiftBoxSection, skipOffstage: false),
    );
    for (final asset in [
      _mainGift,
      for (var index = 1; index <= 5; index++)
        'assets/images/decorations/present$index.png',
      'assets/images/gallery/qr_hus.jpeg',
      'assets/images/gallery/qr_Wife.jpeg',
    ]) {
      await precacheImage(AssetImage(asset), context);
    }
  });
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  return controller;
}

Future<void> _revealGift(
  WidgetTester tester,
  ScrollController controller,
) async {
  controller.jumpTo(1000);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 1300));
  await tester.pump(const Duration(milliseconds: 100));
  expect(_imageAt(_mainGift), findsOneWidget);
  expect(tester.binding.hasScheduledFrame, isTrue);
}
