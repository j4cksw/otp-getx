import 'package:get/get.dart';
import 'package:otp_getx/screens/otp_navigation.dart';
import 'package:otp_getx/screens/otp_repository.dart';

class OtpScreenController extends GetxController {
  RxBool isLoading = true.obs;

  late OtpNavigation navigation;
  late OtpRepository otpRepository;

  OtpScreenController(
      {this.navigation = const OtpNavigation(),
      required this.otpRepository});

  Future<void> onOtpChanged(String value) async {
    if (value.length < 6) return;

    isLoading.value = true;
    await otpRepository.verifyOtp();
    navigation.toSuccess();
  }

  Future<void> requestOtp() async {
    await otpRepository.requestOtp();
    isLoading.value = false;
  }
}
