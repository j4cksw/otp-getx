class OtpRepository {
  const OtpRepository();
  
  Future<void> requestOtp() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> verifyOtp() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}