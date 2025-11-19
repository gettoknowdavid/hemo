import 'package:firebase_auth/firebase_auth.dart';

final class FirebaseAuthService {
  const FirebaseAuthService({required FirebaseAuth auth}) : _auth = auth;

  final FirebaseAuth _auth;

  Stream<User?> get onAuthStateChanged => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();
}
