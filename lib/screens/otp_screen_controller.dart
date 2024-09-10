import 'package:get/get.dart';
import 'package:otp_getx/screens/otp_navigation.dart';
import 'package:otp_getx/screens/otp_repository.dart';

enum OtpScreenStates {
  loadding, loaded, error
}

class OtpScreenController extends GetxController {
  
  Rx<OtpScreenStates> state = OtpScreenStates.loadding.obs;

  late OtpNavigation navigation;
  late OtpAPI otpRepository;

  OtpScreenController(
      {this.navigation = const OtpNavigation(),
      required this.otpRepository});

  Future<void> onOtpChanged(String value) async {
    if (value.length < 6) return;

    state.value = OtpScreenStates.loadding;
    await otpRepository.verifyOtp();
    navigation.toSuccess();
  }

  Future<void> requestOtp() async {
    await otpRepository.requestOtp();
    state.value = OtpScreenStates.loaded;
  }
}
