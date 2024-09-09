import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OtpRepository {
  late http.Client httpClient;

  OtpRepository({required this.httpClient});

  Future<void> requestOtp() async {
    debugPrint('requestOTP');
    await httpClient.get(Uri.parse('http://localhost:8882/otp'));
  }

  Future<void> verifyOtp() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
