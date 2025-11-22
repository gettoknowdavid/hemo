import 'package:firebase_auth/firebase_auth.dart';

typedef SignInParams = ({String email, String password});

typedef SignUpParams = ({String name, String email, String password});

typedef VerifyPhoneNumberParams = ({
  String phoneNumber,
  void Function(PhoneAuthCredential credential) onVerificationCompleted,
  void Function(FirebaseAuthException e) onVerificationFailed,
  void Function(String verificationId, int? resendToken) onCodeSent,
  void Function(String verificationId) onCodeTimeout,
});

typedef LinkPhoneNumberParams = ({String verificationId, String smsCode});
