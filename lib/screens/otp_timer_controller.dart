import 'dart:async';

import 'package:get/get.dart';

enum OtpTimerState { started, stop }

class OtpTimerController extends GetxController {
  RxString time = ''.obs;
  Rx<OtpTimerState> state = OtpTimerState.stop.obs;

  Duration waitingTime;
  late int _remainingInseconds;

  Timer? _timer;

  OtpTimerController({this.waitingTime = const Duration(minutes: 1)});

  start() {
    state.value = OtpTimerState.started;
    time.value = '01:00';
    _remainingInseconds = waitingTime.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingInseconds > 0) {
        _remainingInseconds--;
        time.value = _timeString();
      }
      if (_remainingInseconds == 0) {
        state.value = OtpTimerState.stop;
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
  }

  String _timeString() {
    Duration duration = Duration(seconds: _remainingInseconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
