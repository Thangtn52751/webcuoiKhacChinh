import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/venue/venue_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/widgets/embedded_map.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/widgets/invitation_scroll_view.dart';

void main() {
  testWidgets('mobile loads a map only on demand and releases it offscreen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 700);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InvitationScrollView(
            viewportWidth: 390,
            canvasWidth: 390,
            backgroundAsset: 'assets/images/backgrounds/mainBG.mobile.webp',
            controller: controller,
            children: const [
              SizedBox(height: 900),
              VenueSection(scale: 0.72, loadFromServer: false),
              SizedBox(height: 900),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsNothing);

    controller.jumpTo(900);
    await tester.pumpAndSettle();
    expect(find.text('Chạm để xem bản đồ'), findsOneWidget);
    expect(find.byType(EmbeddedMap), findsNothing);
    await tester.drag(find.text('Chạm để xem bản đồ'), const Offset(0, -70));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(900));
    controller.jumpTo(900);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chạm để xem bản đồ'));
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsOneWidget);
    expect(find.text('Chỉ đường'), findsOneWidget);

    await tester.tap(find.text('Nhà gái'));
    await tester.pump();
    expect(find.byType(EmbeddedMap), findsOneWidget);
    expect(
      tester.widget<EmbeddedMap>(find.byType(EmbeddedMap)).query,
      '21.256900289911776,106.05149489064672',
    );
    expect(find.text('Địa chỉ nhà gái'), findsOneWidget);
    await tester.tap(find.text('Đóng bản đồ để cuộn thiệp'));
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsNothing);

    await tester.tap(find.text('Chạm để xem bản đồ'));
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsOneWidget);
    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsNothing);
    controller.jumpTo(900);
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('viewport resize releases a map without a scroll event', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 1000);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InvitationScrollView(
            viewportWidth: 390,
            canvasWidth: 390,
            backgroundAsset: 'assets/images/backgrounds/mainBG.mobile.webp',
            children: [
              SizedBox(height: 350),
              VenueSection(scale: 0.72, loadFromServer: false),
              SizedBox(height: 900),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chạm để xem bản đồ'));
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsOneWidget);
    tester.view.physicalSize = const Size(390, 200);
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('map is released while the app is hidden', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 700);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: VenueSection(scale: 0.72, loadFromServer: false),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chạm để xem bản đồ'));
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsOneWidget);
    // Focusing the embedded document can make a web app inactive without
    // hiding it; the map must remain usable in that state.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    // Flutter does not render while hidden. The web implementation stops its
    // iframe document directly; after resuming the section must stay closed.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byType(EmbeddedMap), findsNothing);
    expect(find.text('Chạm để xem bản đồ'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('directions keep the exact family coordinates', () {
    const place = VenuePlace(
      side: 'groom',
      title: 'Địa chỉ nhà trai',
      address: '300 Đ. Thân Công Tài',
      latitude: 21.212936479442916,
      longitude: 106.09532359291711,
    );
    expect(place.directionsUri.host, 'www.google.com');
    expect(
      place.directionsUri.queryParameters['destination'],
      '21.212936479442916,106.09532359291711',
    );
  });
}
