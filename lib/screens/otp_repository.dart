import 'package:http/http.dart' as http;

class OtpAPI {
  late http.Client httpClient;

  OtpAPI({required this.httpClient});

  Future<void> requestOtp() async {
    await httpClient.get(Uri.parse('http://localhost:8882/otp'));
  }

  Future<void> verifyOtp() async {
    await httpClient.post(Uri.parse('http://localhost:8882/otp'));
  }
}
