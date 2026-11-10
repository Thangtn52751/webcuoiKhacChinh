import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/pages/wedding_invitation_page.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/guestbook/guestbook_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/widgets/invitation_scroll_view.dart';

const _paper = 'assets/images/backgrounds/mainBG.mobile.webp';

void main() {
  testWidgets(
    'scroll paints visible sections and preserves total paper extent',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 600);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final paints = List.filled(7, 0);
      List<Widget> sections() => [
        for (var index = 0; index < 7; index++)
          _PaintProbe(
            onPaint: () => paints[index]++,
            child: SizedBox(height: 400, child: Text('Section $index')),
          ),
      ];

      final baseline = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: baseline,
              child: Column(children: sections()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      paints.fillRange(0, paints.length, 0);
      baseline.jumpTo(100);
      await tester.pumpAndSettle();
      final baselineCount = paints.where((value) => value > 0).length;
      expect(baselineCount, 7);
      await tester.pumpWidget(const SizedBox.shrink());
      baseline.dispose();

      final controller = ScrollController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InvitationScrollView(
              viewportWidth: 390,
              canvasWidth: 390,
              backgroundAsset: _paper,
              controller: controller,
              children: sections(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(controller.position.maxScrollExtent, 2200);
      final decoration = tester.renderObject<RenderDecoratedSliver>(
        find.byType(DecoratedSliver),
      );
      expect(decoration.geometry!.maxPaintExtent, 2800);

      paints.fillRange(0, paints.length, 0);
      controller.jumpTo(100);
      await tester.pumpAndSettle();
      final visibleCount = paints.where((value) => value > 0).length;
      expect(visibleCount, 2);
      expect(paints.skip(2), everyElement(0));
      expect(controller.position.maxScrollExtent, 2200);
      debugPrint(
        'Scroll paint audit: Column=$baselineCount/7 sections; '
        'slivers=$visibleCount/7; offscreen sections painted=0/5.',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    },
  );

  testWidgets('unvisited guestbook does not start an offscreen spinner', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 600);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InvitationScrollView(
            viewportWidth: 390,
            canvasWidth: 390,
            backgroundAsset: _paper,
            children: [
              SizedBox(height: 1200),
              GuestbookSection(scale: 0.72),
              SizedBox(height: 400),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byType(CircularProgressIndicator, skipOffstage: false),
      findsNothing,
    );
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('mobile invitation settles idle and survives toolbar resizing', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 700);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final player = AudioPlayer();
    await tester.pumpWidget(
      MaterialApp(home: WeddingInvitationPage(musicPlayer: player)),
    );
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(
      find.byType(CircularProgressIndicator, skipOffstage: false),
      findsNothing,
    );
    final originalGuestbookState = tester.state(
      find.byType(GuestbookSection, skipOffstage: false),
    );
    tester.view.physicalSize = const Size(390, 560);
    await tester.pumpAndSettle();
    expect(
      tester.state(find.byType(GuestbookSection, skipOffstage: false)),
      same(originalGuestbookState),
    );
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

class _PaintProbe extends SingleChildRenderObjectWidget {
  const _PaintProbe({required this.onPaint, required super.child});
  final VoidCallback onPaint;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderPaintProbe(onPaint);
}

class _RenderPaintProbe extends RenderProxyBox {
  _RenderPaintProbe(this.onPaint);
  final VoidCallback onPaint;

  @override
  void paint(PaintingContext context, Offset offset) {
    onPaint();
    super.paint(context, offset);
  }
}
