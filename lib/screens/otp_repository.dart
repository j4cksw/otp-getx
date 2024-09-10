import 'package:http/http.dart' as http;

class OtpAPI {
  late http.Client httpClient;

  OtpAPI({required this.httpClient});

  Future<void> requestOtp() async {
    final response = await httpClient.get(Uri.parse('http://localhost:8882/otp'));
    if(response.statusCode!=200) {
      throw RequestOTPError();
    }
  }

  Future<void> verifyOtp() async {
    await httpClient.post(Uri.parse('http://localhost:8882/otp'));
  }
}

class RequestOTPError {
}