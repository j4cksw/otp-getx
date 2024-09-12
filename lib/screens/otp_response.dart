class RequestOtpResponse {
  final String phoneNumber;

  RequestOtpResponse({required this.phoneNumber});

  factory RequestOtpResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'phoneNumber': String phoneNumber,
      } =>
        RequestOtpResponse(
          phoneNumber: phoneNumber,
        ),
      _ => throw const FormatException('Failed to request otp.'),
    };
  }
}
