import 'package:flutter_test/flutter_test.dart';
import 'package:otp_getx/screens/otp_timer_controller.dart';

void main() {
  test('should be in stop state at beginning', () {
    final controller = OtpTimerController();

    expect(controller.state.value, OtpTimerState.stop);
    expect(controller.time.value, '');
  });

  test('should set state to start when call start()', () {
    final controller = OtpTimerController();

    controller.start();

    expect(controller.state.value, OtpTimerState.started);
  });

  test('should set start time when start ', () {
    final controller = OtpTimerController();

    controller.start();

    expect(controller.time.value, '01:00');
  });

    test('should set time value with the timer progress ', () async {
    final controller = OtpTimerController();

    controller.start();

    expect(controller.time.value, '01:00');
  });
}