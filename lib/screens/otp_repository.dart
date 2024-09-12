import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:otp_getx/screens/otp_response.dart';

class OtpAPI {
  late http.Client httpClient;

  OtpAPI({required this.httpClient});

  Future<RequestOtpResponse> requestOtp() async {
    final response =
        await httpClient.get(Uri.parse('http://localhost:8882/otp'));
    if (response.statusCode != 200) {
      throw RequestOTPError();
    }

    return RequestOtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<void> verifyOtp() async {
    final response = await httpClient.post(Uri.parse('http://localhost:8882/otp'));
    if (response.statusCode != 200) {
      throw VerifyOTPError();
    }
  }
}

class RequestOTPError {}

class VerifyOTPError {}
