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
      when(() => httpClient.get(Uri.parse('http://localhost:8882/otp')))
          .thenAnswer((_) async => await Future.delayed(
              const Duration(seconds: 1),
              () => http.Response('{"phoneNumber":"0867937909"}', 200)));

      final resposne = await repo.requestOtp();

      expect(resposne.phoneNumber, '0867937909');
      verify(() => httpClient.get(Uri.parse('http://localhost:8882/otp')));
    });

    test('should throw error when response code is not 200', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => response.body).thenReturn('');
      when(() => httpClient.get(any()))
          .thenAnswer((_) => Future.value(response));

      expect(
          () async => await repo.requestOtp(), throwsA(isA<RequestOTPError>()));
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
