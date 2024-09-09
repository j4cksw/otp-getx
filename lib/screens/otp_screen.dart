import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';

class OtpScreen extends StatelessWidget {
  final OtpScreenController otpScreenController =
      Get.find();

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
    return otpScreenController.isLoading.value
        ? _renderLoading()
        : _renderOtpInput();
  }

  Widget _renderOtpInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'OTP input here',
          ),
          TextField(
            key: const Key('otp_input'),
            onChanged: otpScreenController.onOtpChanged,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _renderLoading() {
    return const CircularProgressIndicator(
      key: Key('loading'),
    );
  }
}
