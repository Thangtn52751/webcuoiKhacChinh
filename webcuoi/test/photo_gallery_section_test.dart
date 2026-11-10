import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/photo_gallery/photo_gallery_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/widgets/invitation_scroll_view.dart';

const _fullImages = [
  'assets/images/couple/full/couple.webp',
  'assets/images/couple/full/couple2.webp',
  'assets/images/couple/full/couple3.webp',
];
const _thumbnails = [
  'assets/images/couple/thumbnails/couple.webp',
  'assets/images/couple/thumbnails/couple2.webp',
  'assets/images/couple/thumbnails/couple3.webp',
];

void main() {
  testWidgets(
    'mobile album swipes and advances every three seconds cyclically',
    (tester) async {
      await _pumpGallery(tester);
      expect(find.text('1 / 3'), findsOneWidget);
      expect(_thumbnailImages().evaluate().length, lessThanOrEqualTo(3));

      await tester.drag(find.byType(PageView), const Offset(-240, 0));
      await tester.pumpAndSettle();
      expect(find.text('2 / 3'), findsOneWidget);

      await _advanceAutomatically(tester);
      expect(find.text('3 / 3'), findsOneWidget);
      await _advanceAutomatically(tester);
      expect(find.text('1 / 3'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'mobile album permits vertical page scrolling and pauses hidden',
    (tester) async {
      await _pumpGallery(tester);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('1 / 3'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await _advanceAutomatically(tester);
      expect(find.text('2 / 3'), findsOneWidget);

      await tester.drag(find.byType(PageView), const Offset(0, -700));
      await tester.pumpAndSettle();
      final position = Scrollable.of(tester.element(find.text('ALBUM ẢNH')))
          .position;
      expect(position.pixels, greaterThan(0));
      expect(find.byType(PageView), findsNothing);
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('2 / 3'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('mobile album opens originals and synchronizes after lightbox', (
    tester,
  ) async {
    await _pumpGallery(tester);
    await tester.tap(_imageAt(_thumbnails.first).hitTestable());
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsWidgets);
    expect(_imageAt(_fullImages.first), findsWidgets);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('1 / 3'), findsNWidgets(2));
    await tester.drag(find.byType(PageView).last, const Offset(-390, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('album stays deferred and pauses outside a sliver viewport', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InvitationScrollView(
            controller: controller,
            viewportWidth: 390,
            canvasWidth: 390,
            backgroundAsset: 'assets/images/backgrounds/mainBG.mobile.webp',
            children: const [
              SizedBox(height: 1200),
              PhotoGallerySection(
                scale: 0.72,
                imagePaths: _fullImages,
                thumbnailPaths: _thumbnails,
              ),
              SizedBox(height: 1600),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PageView, skipOffstage: false), findsNothing);
    tester.view.physicalSize = const Size(390, 1400);
    await tester.pumpAndSettle();
    expect(find.byType(PageView, skipOffstage: false), findsOneWidget);
    tester.view.physicalSize = const Size(390, 800);
    await tester.pumpAndSettle();
    expect(find.byType(PageView, skipOffstage: false), findsNothing);
    controller.jumpTo(1200);
    await tester.pumpAndSettle();
    expect(find.byType(PageView, skipOffstage: false), findsOneWidget);
    await _advanceAutomatically(tester);
    expect(find.text('2 / 3'), findsOneWidget);
    controller.jumpTo(2200);
    await tester.pumpAndSettle();
    expect(find.byType(PageView, skipOffstage: false), findsNothing);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('2 / 3', skipOffstage: false), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Finder _imageAt(String path) => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName == path,
);

Finder _thumbnailImages() => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName.contains('/thumbnails/'),
);

Future<void> _pumpGallery(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 800);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              PhotoGallerySection(
                scale: 0.72,
                imagePaths: _fullImages,
                thumbnailPaths: _thumbnails,
              ),
              SizedBox(height: 1600),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _advanceAutomatically(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pumpAndSettle();
}
