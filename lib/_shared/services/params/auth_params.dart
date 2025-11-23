import 'package:firebase_auth/firebase_auth.dart';

typedef SignInParams = ({String email, String password});

typedef SignUpParams = ({String name, String email, String password});

/// Parameters for verifying phone number
typedef VerifyMobileParams = ({
  String phoneNumber,
  void Function(PhoneAuthCredential credential) onVerificationCompleted,
  void Function(FirebaseAuthException e) onVerificationFailed,
  void Function(String verificationId, int? resendToken) onCodeSent,
  void Function(String verificationId) onCodeTimeout,
});

/// Parameters for linking phone number
typedef LinkMobileParams = ({String verificationId, String smsCode});
