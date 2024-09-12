import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:otp_getx/main.dart';
import 'package:otp_getx/screens/otp_screen.dart';
import 'package:otp_getx/screens/verify_success_screen.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeURI extends Mock implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
  });

  tearDown(() {
    Get.reset();
    //mockHttpClient.c
  });

  testWidgets('Verify OTP success', (WidgetTester tester) async {
    _arrangeVerifySuccess(mockHttpClient);

    await tester.pumpWidget(MyApp(httpClient: mockHttpClient));

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

  testWidgets('Request OTP fail', (WidgetTester tester) async {
    _arrangeFailedOnRequestOTP(mockHttpClient);

    await tester.pumpWidget(MyApp(httpClient: mockHttpClient));

    // Show loading at start
    expect(find.byKey(const Key('loading')), findsOne);

    // Wait until loading finished
    await tester.pumpAndSettle();

    // Should see error message
    expect(find.byKey(const Key('error_request_otp')), findsOneWidget);

    // Hit retry button should see loading again
    await tester.tap(find.byKey(const Key('error_request_otp_retry')));
    await tester.pump();

    expect(find.byKey(const Key('loading')), findsOne);
  });

  testWidgets('User can get a hint of OTP sent to his phone',
      (WidgetTester tester) async {
    _arrangeVerifySuccess(mockHttpClient);

    await tester.pumpWidget(MyApp(httpClient: mockHttpClient));

    // Wait until loading finished
    await tester.pumpAndSettle();

    // Should see otp sent message masked phone number
    expect(find.text('OTP code was sent to 086***7909'), findsOneWidget);
  });
}

void _arrangeVerifySuccess(MockHttpClient mockHttpClient) {
  when(() => mockHttpClient.get(Uri.parse('http://localhost:8882/otp')))
      .thenAnswer((_) async => await Future.delayed(
          const Duration(seconds: 1), () => http.Response('{"phoneNumber":"0867937909"}', 200)));
  when(() => mockHttpClient.post(Uri.parse('http://localhost:8882/otp')))
      .thenAnswer((_) async => await Future.delayed(
          const Duration(seconds: 1), () => http.Response('{}', 200)));
}

void _arrangeFailedOnRequestOTP(MockHttpClient mockHttpClient) {
  when(() => mockHttpClient.get(Uri.parse('http://localhost:8882/otp')))
      .thenAnswer((_) async => await Future.delayed(
          const Duration(seconds: 1), () => http.Response('{}', 400)));
}
