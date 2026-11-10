import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/guestbook/guestbook_section.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/guestbook/widgets/guestbook_form.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/sections/party_section/widgets/party_section_actions.dart';
import 'package:webcuoi/features/wedding_invitation/presentation/widgets/invitation_scroll_view.dart';

void main() {
  testWidgets('deferred guestbook retains drafts and RSVP still submits', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 700);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      final isGuestbook = request.url.path.endsWith('/guestbook');
      final data = request.method == 'GET'
          ? <Object>[]
          : isGuestbook
          ? jsonDecode(request.body)
          : <String, Object>{'accepted': true};
      return http.Response(
        jsonEncode({'data': data}),
        request.method == 'GET' ? 200 : 201,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
    addTearDown(client.close);
    final controller = ScrollController();
    addTearDown(controller.dispose);

    // All requests stay in this mock; the test never sends a wish or an email.
    await http.runWithClient(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InvitationScrollView(
              controller: controller,
              viewportWidth: 390,
              canvasWidth: 390,
              backgroundAsset: 'assets/images/backgrounds/mainBG.mobile.webp',
              children: const [
                PartySectionActions(scale: 0.72),
                SizedBox(height: 900),
                GuestbookSection(scale: 0.72),
                SizedBox(height: 900),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(requests, isEmpty);

      controller.jumpTo(1000);
      await tester.pumpAndSettle();
      expect(requests.single.method, 'GET');
      final inputs = find.descendant(
        of: find.byType(GuestbookForm),
        matching: find.byType(TextField),
      );
      await tester.enterText(inputs.at(0), 'Khách thử nghiệm');
      await tester.enterText(inputs.at(1), 'Chúc hai bạn hạnh phúc!');
      controller.jumpTo(0);
      await tester.pumpAndSettle();
      controller.jumpTo(1000);
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(inputs.at(0)).controller!.text,
        'Khách thử nghiệm',
      );
      expect(
        tester.widget<TextField>(inputs.at(1)).controller!.text,
        'Chúc hai bạn hạnh phúc!',
      );
      expect(
        requests,
        hasLength(1),
        reason: 'Revisiting must not reload data.',
      );
      await tester.tap(find.text('GỬI LỜI CHÚC'));
      await tester.pumpAndSettle();
      expect(requests.last.method, 'POST');
      expect(requests.last.url.path, endsWith('/guestbook'));
      expect(jsonDecode(requests.last.body), {
        'name': 'Khách thử nghiệm',
        'message': 'Chúc hai bạn hạnh phúc!',
      });
      expect(tester.widget<TextField>(inputs.at(0)).controller!.text, isEmpty);
      expect(tester.widget<TextField>(inputs.at(1)).controller!.text, isEmpty);
      expect(find.text('Chúc hai bạn hạnh phúc!'), findsOneWidget);

      controller.jumpTo(0);
      await tester.pumpAndSettle();
      await tester.tap(find.text('XÁC NHẬN THAM DỰ'));
      await tester.pumpAndSettle();
      final submit = find.widgetWithText(ElevatedButton, 'Gửi xác nhận');
      expect(tester.widget<ElevatedButton>(submit).onPressed, isNull);
      await tester.enterText(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(TextField),
        ),
        'Khách RSVP',
      );
      await tester.tap(find.text('Rất tiếc, tôi không thể đến'));
      await tester.pump();
      expect(tester.widget<ElevatedButton>(submit).onPressed, isNotNull);
      await tester.tap(submit);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(requests.last.url.path, endsWith('/rsvps'));
      expect(jsonDecode(requests.last.body), {
        'guestName': 'Khách RSVP',
        'attendance': 'not-attending',
        'guestCount': 0,
        'note': '',
      });
      expect(requests, hasLength(3));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    }, () => client);
  });
}
