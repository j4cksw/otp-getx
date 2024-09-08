import 'package:get/get.dart';
import 'package:otp_getx/screens/verify_success_screen.dart';

class OtpNavigation {
  const OtpNavigation();

  toSuccess() {
    Get.to(const VerifySuccessScreen());
  }
}