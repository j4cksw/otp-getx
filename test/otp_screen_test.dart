import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:otp_getx/screens/otp_screen.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';
import 'package:otp_getx/screens/otp_timer_controller.dart';

class MockOtpScreenController extends GetxController
    with Mock
    implements OtpScreenController {}

class MockOtpTimerController extends GetxController
    with Mock
    implements OtpTimerController {}

void main() {
  late MockOtpScreenController mockOtpController;
  late MockOtpTimerController mockOtpTimerController;

  setUp(() {
    mockOtpController = MockOtpScreenController();
    when(() => mockOtpController.phoneNumber).thenReturn("".obs);
    when(
      () => mockOtpController.requestOtp(),
    ).thenAnswer((_) => Future.value());

    mockOtpTimerController = MockOtpTimerController();
    when(() => mockOtpTimerController.state)
        .thenReturn(OtpTimerState.started.obs);
    when(() => mockOtpTimerController.time).thenReturn(''.obs);
  });

  Widget createOtpScreen() {
    Get.replace<OtpScreenController>(mockOtpController);
    Get.replace<OtpTimerController>(mockOtpTimerController);

    return GetMaterialApp(
      title: 'Flutter Demo',
      home: OtpScreen(),
    );
  }

  testWidgets('Show loading at the beginning.', (WidgetTester tester) async {
    when(() => mockOtpController.state)
        .thenReturn(OtpScreenStates.loadding.obs);
    await tester.pumpWidget(createOtpScreen());

    expect(find.byKey(const Key('loading')), findsOneWidget);
    verify(() => mockOtpController.requestOtp());
    verify(() => mockOtpTimerController.start());
  });

  testWidgets('Show OTP input when loading finished',
      (WidgetTester tester) async {
    when(() => mockOtpController.state).thenReturn(OtpScreenStates.loaded.obs);

    await tester.pumpWidget(createOtpScreen());

    expect(find.byKey(const Key('loading')), findsNothing);
    expect(find.byKey(const Key('otp_input')), findsOneWidget);
  });

  testWidgets('Show OTP sent message when loading finished',
      (WidgetTester tester) async {
    when(() => mockOtpController.phoneNumber).thenReturn('086***7909'.obs);
    when(() => mockOtpController.state).thenReturn(OtpScreenStates.loaded.obs);

    await tester.pumpWidget(createOtpScreen());

    expect(find.text('OTP code was sent to 086***7909'), findsOneWidget);
  });

  testWidgets('show loading when input OTP code completed',
      (WidgetTester tester) async {
    when(() => mockOtpController.state).thenReturn(OtpScreenStates.loaded.obs);
    when(() => mockOtpController.onOtpChanged(any()))
        .thenAnswer((_) => Future.value());

    await tester.pumpWidget(createOtpScreen());

    await tester.enterText(find.byKey(const Key('otp_input')), '123456');

    verify(() => mockOtpController.onOtpChanged('123456'));
  });

  testWidgets('should show error when request otp fail',
      (WidgetTester tester) async {
    when(() => mockOtpController.state).thenReturn(OtpScreenStates.error.obs);

    await tester.pumpWidget(createOtpScreen());

    expect(find.byKey(const Key('error_request_otp')), findsOneWidget);
  });

  testWidgets('should show timer when start', (WidgetTester tester) async {
    when(() => mockOtpController.state).thenReturn(OtpScreenStates.loaded.obs);
    when(() => mockOtpTimerController.time).thenReturn('01:00'.obs);

    await tester.pumpWidget(createOtpScreen());

    expect(find.text('01:00'), findsOneWidget);
  });

  testWidgets('should show resend button when timer stop',
      (WidgetTester tester) async {
    when(() => mockOtpController.state).thenReturn(OtpScreenStates.loaded.obs);
    when(() => mockOtpTimerController.time).thenReturn('01:00'.obs);
    when(() => mockOtpTimerController.state).thenReturn(OtpTimerState.stop.obs);

    await tester.pumpWidget(createOtpScreen());

    expect(find.byKey(const Key('resend')), findsOneWidget);
    await tester.tap(find.byKey(const Key('resend')));

    verify(() => mockOtpController.requestOtp()).called(2);
    verify(() => mockOtpTimerController.start()).called(2);
  });
}
