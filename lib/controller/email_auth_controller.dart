import 'package:email_otp/email_otp.dart';

EmailOTP myAuth = EmailOTP();
void sendOTP(String email) async {
  await myAuth.setConfig(
      appName: 'Exam App',
      otpLength: 5,
      otpType: OTPType.digitsOnly,
      userEmail: email);
  if (await myAuth.sendOTP()) {
    print('Send OTP successfully');
  } else {
    print("error");
  }
}

Future<bool> verifyOTP(String otp) async {
  bool result = await myAuth.verifyOTP(otp: otp);
  if (result) {
    print('Verify successfully');
    return true;
  }
  print('Wrong otp');
  return false;
}
