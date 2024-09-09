import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:otp_getx/screens/otp_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeURI extends Mock implements Uri {}

void main() {
  final httpClient = MockHttpClient();
  final repo = OtpAPI(httpClient: httpClient);

  setUpAll(() {
    registerFallbackValue(FakeURI());
  });

  group('requestOtp', () {
    test('should get request', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('');
      when(() => httpClient.get(any()))
          .thenAnswer((_) => Future.value(response));

      await repo.requestOtp();

      verify(() => httpClient.get(Uri.parse('http://localhost:8882/otp')));
    });
  });

  group('verifyOtp', () {
    test('should request to verifyOTP API ', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('');
      when(() => httpClient.post(any()))
          .thenAnswer((_) => Future.value(response));

      await repo.verifyOtp();

      verify(() => httpClient.post(Uri.parse('http://localhost:8882/otp')));
    });
  });
}
