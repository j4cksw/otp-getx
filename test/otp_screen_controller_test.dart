import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:otp_getx/screens/otp_navigation.dart';
import 'package:otp_getx/screens/otp_repository.dart';
import 'package:otp_getx/screens/otp_response.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';

class MockOtpNavigation extends Mock implements OtpNavigation {}

class MockOtpRepository extends Mock implements OtpAPI {}

void main() {
  late OtpScreenController controller;
  late OtpNavigation otpNavigation;
  late OtpAPI otpRepository;

  setUp(() {
    otpNavigation = MockOtpNavigation();
    otpRepository = MockOtpRepository();
    controller = OtpScreenController(
        navigation: otpNavigation, otpRepository: otpRepository);
  });

  group('requestOtp', () {
    for (var testCase in [
      OtpScreenStates.loadding,
      OtpScreenStates.loaded,
      OtpScreenStates.error
    ]) {
      test('should set loading state when start from $testCase', () {
        _arrangeRequestOTPSuccess(otpRepository);

        controller.state.value = testCase;

        controller.requestOtp();

        expect(controller.state.value, OtpScreenStates.loadding);
        verify(() => otpRepository.requestOtp());
      });
    }

    test('should set loaded state when get response', () async {
      _arrangeRequestOTPSuccess(otpRepository);

      await controller.requestOtp();

      expect(controller.state.value, OtpScreenStates.loaded);
    });

    test('should set phone number when get response', () async {
      _arrangeRequestOTPSuccess(otpRepository);

      await controller.requestOtp();

      expect(controller.phoneNumber.value, '086***7909');
    });

    test('should set error state when get error response', () async {
      when(() => otpRepository.requestOtp()).thenThrow(RequestOTPError());

      await controller.requestOtp();

      expect(controller.state.value, OtpScreenStates.error);
    });
  });

  group('onOtpChanged', () {
    test('should set loading to true when input complete OTP code', () async {
      when(() => otpRepository.verifyOtp())
          .thenAnswer((_) => Future.delayed(const Duration()));
      controller.state.value = OtpScreenStates.loaded;
      await controller.onOtpChanged('123456');

      expect(controller.state.value, OtpScreenStates.loadding);
      verify(() => otpNavigation.toSuccess());
    });

    for (var testCase in ['1', '12', '123', '1234', '12345']) {
      test(
          'should NOT set loading to true when input partial OTP code $testCase',
          () async {
        controller.state.value = OtpScreenStates.loaded;

        await controller.onOtpChanged(testCase);

        expect(controller.state.value, OtpScreenStates.loaded);
        verifyNever(() => otpNavigation.toSuccess());
      });
    }
  });
}

void _arrangeRequestOTPSuccess(OtpAPI otpRepository) {
  when(() => otpRepository.requestOtp()).thenAnswer(
      (_) => Future.value(RequestOtpResponse(phoneNumber: '0867937909')));
}
