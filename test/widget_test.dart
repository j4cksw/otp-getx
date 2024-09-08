// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/instance_manager.dart';

import 'package:otp_getx/main.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';

void main() {
  testWidgets('Show loading at the beginning.', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    //await tester.pumpAndSettle();

    // Verify that our counter starts at 0.
    expect(find.byKey(const Key('loading')), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Show OTP input when loading finished',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byKey(const Key('loading')), findsNothing);
    expect(find.byKey(const Key('otp_input')), findsOneWidget);
  });

  testWidgets('show loading when input OTP code completed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.enterText(find.byKey(const Key('otp_input')), '123456');
    await tester.pump();

    expect(find.byKey(const Key('loading')), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('should not show loading when otp code input not completed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.enterText(find.byKey(const Key('otp_input')), '1');
    await tester.pump();

    expect(find.byKey(const Key('loading')), findsNothing);
  });
}
