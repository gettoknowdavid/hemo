import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_models/auth_scope.dart';
import 'package:hemo/_shared/services/models/h_user.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';
import 'package:logging/logging.dart';

typedef SignInParams = ({String email, String password});

final class AuthManager with ChangeNotifier {
  AuthManager({
    required FirebaseAuthService auth,
    required FirebaseFirestoreService store,
  }) : _auth = auth,
       _store = store;

  final FirebaseAuthService _auth;
  final FirebaseFirestoreService _store;

  final _log = Logger('AUTH_MANAGER');

  late final Command<SignInParams, void> signInCommand = .createAsyncNoResult(
    (params) async {
      final uid = await _auth.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
      await _handleSignIn(uid);
    },
  );

  late final Command<void, void> signOutCommand = .createAsyncNoParamNoResult(
    () async {
      await _auth.signOut();
      await _handleSignOut();
    },
  );

  Future<AuthManager> initialize() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      await _handleSignOut();
    } else {
      await _handleSignIn(firebaseUser.uid);
    }

    return this;
  }

  Future<void> _handleSignOut() async {
    if (di.hasScope(AuthScope.unauthenticated)) {
      _log.info('UNAUTHENTICATED. POPPING SCOPE');
      await di.popScope();
    } else {
      _log.info('UNAUTHENTICATED. PUSHING "unauthenticated" SCOPE');
      di.pushNewScope(scopeName: AuthScope.unauthenticated);
      di.registerSingleton<HUser>(HUser.empty());
    }

    notifyListeners();
  }

  Future<void> _handleSignIn(String uid) async {
    try {
      final user = await _store.getUser(uid);

      _log.info('AUTHENTICATED ::: PUSHING "authenticated" SCOPE');
      di.pushNewScope(scopeName: AuthScope.authenticated);
      di.registerSingleton<HUser>(user);
    } on Exception catch (error) {
      _log.severe('ERROR FETCHING USER FROM DB, FORCING SIGN_OUT', error);

      await _auth.signOut();
      await _handleSignOut();
    } finally {
      notifyListeners();
    }
  }
}
