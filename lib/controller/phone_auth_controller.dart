import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthController {
  static String verify = "";
  static void sendOtp(String phoneNum) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: '+84$phoneNum',
      codeSent: (String verificationId, int? resendToken) async {
        verify = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException error) {},
    );
  }

  static Future<bool> verifyPhone(String sms) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verify, smsCode: sms);

      // Sign the user in (or link) with the credential
      await auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Wrong otp');
      return false;
    }
  }
}
