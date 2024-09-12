import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:otp_getx/screens/otp_screen.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';

class MockOtpScreenController extends GetxController with Mock implements OtpScreenController {}


void main() {

  late MockOtpScreenController mockController;

  setUp(() {
    mockController = MockOtpScreenController();
    when(() => mockController.phoneNumber).thenReturn("".obs);
    when(() => mockController.requestOtp(),).thenAnswer((_)=>Future.value());
  });

  
  testWidgets('Show loading at the beginning.', (WidgetTester tester) async {
    when(() => mockController.state).thenReturn(OtpScreenStates.loadding.obs);
    await tester.pumpWidget(_createOtpScreen(mockController));

    expect(find.byKey(const Key('loading')), findsOneWidget);
    verify(()=>mockController.requestOtp());
  });

  testWidgets('Show OTP input when loading finished',
      (WidgetTester tester) async {
    when(() => mockController.state).thenReturn(OtpScreenStates.loaded.obs);

    await tester.pumpWidget(_createOtpScreen(mockController));

    expect(find.byKey(const Key('loading')), findsNothing);
    expect(find.byKey(const Key('otp_input')), findsOneWidget);
  });

  testWidgets('Show OTP sent message when loading finished', (WidgetTester tester) async {
    when(() => mockController.phoneNumber).thenReturn('086***7909'.obs);
    when(() => mockController.state).thenReturn(OtpScreenStates.loaded.obs);

    await tester.pumpWidget(_createOtpScreen(mockController));

    expect(find.text('OTP code was sent to 086***7909'), findsOneWidget);
  });

  testWidgets('show loading when input OTP code completed',
      (WidgetTester tester) async {
    when(() => mockController.state).thenReturn(OtpScreenStates.loaded.obs);
    when(() => mockController.onOtpChanged(any())).thenAnswer((_)=>Future.value());

    await tester.pumpWidget(_createOtpScreen(mockController));

    await tester.enterText(find.byKey(const Key('otp_input')), '123456');
    
    verify(() => mockController.onOtpChanged('123456'));
  });

  testWidgets('should show error when request otp fail', (WidgetTester tester) async {
    when(() => mockController.state).thenReturn(OtpScreenStates.error.obs);
    
    await tester.pumpWidget(_createOtpScreen(mockController));

    expect(find.byKey(const Key('error_request_otp')), findsOneWidget);
  });
}

Widget _createOtpScreen(MockOtpScreenController mockController) {
  Get.replace<OtpScreenController>(mockController);
  return GetMaterialApp(
      title: 'Flutter Demo',
      home: OtpScreen(),
    );
}
