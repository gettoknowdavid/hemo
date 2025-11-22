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

  Future<void> verifyPhoneNumber(VerifyPhoneNumberParams params) {
    return _auth.verifyPhoneNumber(
      phoneNumber: params.phoneNumber,
      verificationCompleted: params.onVerificationCompleted,
      verificationFailed: params.onVerificationFailed,
      codeSent: params.onCodeSent,
      codeAutoRetrievalTimeout: params.onCodeTimeout,
    );
  }

  Future<void> linkPhoneNumber(LinkPhoneNumberParams params) async {
    final user = _auth.currentUser;
    if (user == null) throw const UnauthenticatedException();

    final credential = PhoneAuthProvider.credential(
      verificationId: params.verificationId,
      smsCode: params.smsCode,
    );

    final assertion = PhoneMultiFactorGenerator.getAssertion(credential);
    await user.multiFactor.enroll(assertion);
  }
}
