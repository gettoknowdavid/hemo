import 'package:firebase_auth/firebase_auth.dart';

final class FirebaseAuthService {
  const FirebaseAuthService(FirebaseAuth auth) : _auth = auth;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

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
