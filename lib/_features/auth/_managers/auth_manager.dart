import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_shared/services/models/h_user.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';
import 'package:hemo/_shared/utils/h_logger.dart';

typedef LoginParams = ({String email, String password});

final class AuthManager with ChangeNotifier, HLoggerMixin {
  AuthManager({
    required FirebaseAuthService auth,
    required FirebaseFirestoreService store,
  }) : _auth = auth,
       _store = store {
    // Initialize the manager
    _initializeManager();
  }

  final FirebaseAuthService _auth;
  final FirebaseFirestoreService _store;

  final _currentUser = ValueNotifier<HUser?>(null);

  late final Command<LoginParams, void> login = Command.createAsyncNoResult(
    (params) async => _auth.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    ),
  );

  void _initializeManager() {
    // Set initial scope before the first stream event arrives
    di.pushNewScope(scopeName: 'unknown');
    di.registerSingleton<HUser>(HUser.empty());

    // Listen to the raw Firebase stream immediately
    _auth.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser == null) {
        _handleSignOut();
      } else {
        await _handleSignIn(firebaseUser);
      }

      // Notify listeners of AuthManager itself
      notifyListeners();
    });
  }

  void _handleSignOut() {
    if (di.currentScopeName == 'unauthenticated') return;

    log.info('UNAUTHENTICATED. PUSHING "unauthenticated" scope');
    _currentUser.value = null;
    di.pushNewScope(scopeName: 'unauthenticated');
    di.registerSingleton<HUser>(HUser.empty());
  }

  Future<void> _handleSignIn(User firebaseUser) async {
    try {
      final user = await _store.getUser(firebaseUser.uid);
      _currentUser.value = user;

      log.info('AUTHENTICATED ::: PUSHING "unauthenticated" scope');
      di.pushNewScope(scopeName: 'authenticated');
      di.registerSingleton<HUser>(user);
    } on Exception catch (error) {
      log.severe('ERROR FETCHING USER FROM DB, FORCING SIGN_OUT', error);

      await _auth.signOut();
      _currentUser.value = null;
      di.pushNewScope(scopeName: 'unauthenticated');
      di.registerSingleton<HUser>(HUser.empty());
    }
  }
}
