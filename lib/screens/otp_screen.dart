import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';
import 'package:otp_getx/screens/otp_timer_controller.dart';

class OtpScreen extends StatelessWidget {
  final OtpScreenController otpScreenController = Get.find();
  final OtpTimerController otpTimerController = Get.find();

  OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    otpScreenController.requestOtp();

    return Scaffold(
      body: Center(
        child: Obx(() => _renderByLoadingState()),
      ),
    );
  }

  Widget _renderByLoadingState() {
    return switch (otpScreenController.state.value) {
      OtpScreenStates.error => _renderError(),
      OtpScreenStates.loadding => _renderLoading(),
      OtpScreenStates.loaded => _renderOtpInput(),
    };
  }

  Widget _renderError() => Column(
        key: const Key('error_request_otp'),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Error, please try again.',
          ),
          TextButton(
              key: const Key('error_request_otp_retry'),
              onPressed: otpScreenController.requestOtp,
              child: const Text('RETRY')),
        ],
      );

  Widget _renderOtpInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'OTP code was sent to ${otpScreenController.phoneNumber}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 48,
          ),
          const Text(
            'OTP input here',
          ),
          TextField(
            key: const Key('otp_input'),
            onChanged: otpScreenController.onOtpChanged,
            textAlign: TextAlign.center,
          ),
          _renderResend(),
        ],
      ),
    );
  }

  Widget _renderResend() {
    return switch (otpTimerController.state.value) {
      OtpTimerState.started => Text(otpTimerController.time.value),
      OtpTimerState.stop => TextButton(
          key: const Key('resend'),
          onPressed: otpScreenController.requestOtp,
          child: const Text('RESEND'))
    };
  }

  Widget _renderLoading() {
    return const CircularProgressIndicator(
      key: Key('loading'),
    );
  }
}
