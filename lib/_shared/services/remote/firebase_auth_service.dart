import 'package:firebase_auth/firebase_auth.dart';
import 'package:hemo/_shared/services/models/h_user.dart';

final class FirebaseAuthService {
  const FirebaseAuthService({required FirebaseAuth auth}) : _auth = auth;

  final FirebaseAuth _auth;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!.uid;
  }

  Future<void> signOut() => _auth.signOut();
}
