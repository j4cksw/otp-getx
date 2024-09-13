import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:otp_getx/screens/otp_repository.dart';
import 'package:otp_getx/screens/otp_screen.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';
import 'package:otp_getx/screens/otp_timer_controller.dart';

void main() {
  runApp(MyApp(httpClient: Client()));
}

class MyApp extends StatelessWidget {
  final Client httpClient;

  const MyApp({super.key, required this.httpClient});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(OtpScreenController(otpRepository: OtpAPI(httpClient: httpClient)));
    Get.put(OtpTimerController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OtpScreen(),
    );
  }
}
