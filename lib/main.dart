import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:otp_getx/screens/otp_repository.dart';
import 'package:otp_getx/screens/otp_screen.dart';
import 'package:otp_getx/screens/otp_screen_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Get.put(OtpScreenController(otpRepository: OtpRepository(httpClient: Client())));
    
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

