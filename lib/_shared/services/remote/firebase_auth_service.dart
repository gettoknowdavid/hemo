import 'package:firebase_auth/firebase_auth.dart';
import 'package:hemo/_shared/services/exceptions/h_exception.dart';
import 'package:hemo/_shared/services/params/auth_params.dart';

final class FirebaseAuthService {
  const FirebaseAuthService(FirebaseAuth auth) : _auth = auth;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<String> signIn(SignInParams params) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
    return credential.user!.uid;
  }

  Future<User> signUp(SignUpParams params) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );

    final user = credential.user;
    if (user == null) throw const CreateUserException();

    await user.updateDisplayName(params.name);

    if (!user.emailVerified) await user.sendEmailVerification();

    await user.reload();
    return _auth.currentUser!;
  }

  Future<bool> checkEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw const UnauthenticatedException();
    await user.reload();
    return user.emailVerified;
  }

  Future<void> resendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw const UnauthenticatedException();
    if (!user.emailVerified) return user.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required void Function(PhoneAuthCredential cred) onVerificationCompleted,
    required void Function(FirebaseAuthException e) onVerificationFailed,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(String verificationId) onCodeTimeout,
    int? forceResendingToken,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeTimeout,
      forceResendingToken: forceResendingToken,
    );
  }

  Future<void> linkPhoneNumber(LinkMobileParams params) async {
    final user = _auth.currentUser;
    if (user == null) throw const UnauthenticatedException();

    final credential = PhoneAuthProvider.credential(
      verificationId: params.verificationId,
      smsCode: params.smsCode,
    );

    await user.linkWithCredential(credential);

    await user.reload();
  }
}
