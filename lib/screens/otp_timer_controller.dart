import 'package:get/get.dart';

enum OtpTimerState {
  started, stop
}

class OtpTimerController extends GetxController {
  RxString time = ''.obs;
  Rx<OtpTimerState> state = OtpTimerState.stop.obs;

  start() {
    state.value = OtpTimerState.started;
    time.value = '01:00';
  }
}