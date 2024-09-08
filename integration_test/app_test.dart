import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/instance_manager.dart';
import 'package:otp_getx/main.dart';
import 'package:otp_getx/screens/otp_screen.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';
import 'package:otp_getx/screens/verify_success_screen.dart';

void main() {
  
  testWidgets('Verify OTP success', (WidgetTester tester) async {

    await tester.pumpWidget(const MyApp());

    // Show loading at start
    expect(find.byKey(const Key('loading')), findsOne);

    // Wait until loading finished
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('loading')), findsNothing);
    expect(find.byKey(const Key('otp_input')), findsOneWidget);

    // Input OTP
    await tester.enterText(find.byKey(const Key('otp_input')), '123456');
    // If use pump and settle, it will wait forever.
    await tester.pump();

    // Should show loadding again
    expect(find.byKey(const Key('loading')), findsOne);

    await tester.pumpAndSettle(const Duration(seconds: 2));
    // When success should show success screen
    expect(find.byType(OtpScreen), findsNothing);
    expect(find.byType(VerifySuccessScreen), findsOneWidget);
  });
}