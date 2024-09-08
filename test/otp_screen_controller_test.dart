import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:otp_getx/screens/otp_navigation.dart';
import 'package:otp_getx/screens/otp_repository.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';

class MockOtpNavigation extends Mock implements OtpNavigation {}

class MockOtpRepository extends Mock implements OtpRepository {}

void main() {
  late OtpScreenController controller;
  late OtpNavigation otpNavigation;
  late OtpRepository otpRepository;

  setUp(() {
    otpNavigation = MockOtpNavigation();
    otpRepository = MockOtpRepository();
    controller = OtpScreenController(
        navigation: otpNavigation, otpRepository: otpRepository);
  });

  group('requestOtp', () {
    test('should set loading to true when start', () {
      when(() => otpRepository.requestOtp())
          .thenAnswer((_) => Future.delayed(const Duration()));

      controller.requestOtp();

      expect(controller.isLoading.value, true);
      verify(() => otpRepository.requestOtp());
    });

    test('should set loading to false when get response', () async {
      when(() => otpRepository.requestOtp())
          .thenAnswer((_) => Future.delayed(const Duration()));

      await controller.requestOtp();

      expect(controller.isLoading.value, false);
    });
  });

  group('onOtpChanged', () {
    test('should set loading to true when input complete OTP code', () async {
      when(() => otpRepository.verifyOtp())
          .thenAnswer((_) => Future.delayed(const Duration()));
      controller.isLoading.value = false;

      await controller.onOtpChanged('123456');

      expect(controller.isLoading.value, true);
      verify(() => otpNavigation.toSuccess());
    });

    for (var testCase in ['1', '12', '123', '1234', '12345']) {
      test(
          'should NOT set loading to true when input partial OTP code $testCase',
          () async {
        controller.isLoading.value = false;

        await controller.onOtpChanged(testCase);

        expect(controller.isLoading.value, false);
        verifyNever(() => otpNavigation.toSuccess());
      });
    }
  });
}
