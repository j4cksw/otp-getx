import 'package:get/get.dart';
import 'package:otp_getx/screens/otp_navigation.dart';
import 'package:otp_getx/screens/otp_repository.dart';

enum OtpScreenStates { loadding, loaded, error }

class OtpScreenController extends GetxController {
  Rx<OtpScreenStates> state = OtpScreenStates.loadding.obs;
  RxString phoneNumber = ''.obs;

  late OtpNavigation navigation;
  late OtpAPI otpRepository;

  OtpScreenController(
      {this.navigation = const OtpNavigation(), required this.otpRepository});

  Future<void> requestOtp() async {
    state.value = OtpScreenStates.loadding;
    try {
      final response = await otpRepository.requestOtp();
      phoneNumber.value = mask(response.phoneNumber);
      state.value = OtpScreenStates.loaded;
    } catch (_) {
      state.value = OtpScreenStates.error;
    }
  }

  Future<void> onOtpChanged(String value) async {
    if (value.length < 6) return;

    state.value = OtpScreenStates.loadding;
    await otpRepository.verifyOtp();
    navigation.toSuccess();
  }

  String mask(String input, {int visibleStart = 3, int visibleEnd = 4}) {
    if (input.length <= visibleStart + visibleEnd) {
      return input;
    }

    String start = input.substring(0, visibleStart);
    String end = input.substring(input.length - visibleEnd);
    String masked = '*' * (input.length - visibleStart - visibleEnd);

    return start + masked + end;
  }
}
