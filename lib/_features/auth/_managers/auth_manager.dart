import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_models/auth_scope.dart';
import 'package:hemo/_features/auth/_models/h_user.dart';
import 'package:hemo/_shared/services/models/h_user.dart';
import 'package:hemo/_shared/services/params/auth_params.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';
import 'package:logging/logging.dart';

final class AuthManager with ChangeNotifier {
  AuthManager({
    required FirebaseAuthService auth,
    required FirebaseFirestoreService store,
  }) : _auth = auth,
       _store = store;

  final FirebaseAuthService _auth;
  final FirebaseFirestoreService _store;

  final _log = Logger('AUTH_MANAGER');

  late final Command<SignInParams, void> signIn = .createAsyncNoResult(
    (params) => _auth.signIn(params).then(_handleSignIn),
  );

  late final Command<void, void> signOut = .createAsyncNoParamNoResult(
    () => _auth.signOut().whenComplete(_handleSignOut),
  );

  late final Command<SignUpParams, void> signUp = .createAsyncNoResult(
    (params) => _auth.signUp(params).then(_handleSignUp),
  );

  late final Command<void, bool?> checkVerification = .createAsyncNoParam(
    () => _auth.checkEmailVerification().then(_handleVerification),
    initialValue: null,
  );

  late final Command<void, bool> resendVerificationEmail = .createAsyncNoParam(
    () => _auth.resendEmailVerification().then((_) => true),
    initialValue: false,
  );

  Future<AuthManager> initialize() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      await _handleSignOut();
      return this;
    }

    if (!firebaseUser.emailVerified) {
      if (di.hasScope(AuthScope.unverified)) {
        await di.dropScope(AuthScope.unverified);
      }

      di.pushNewScope(scopeName: AuthScope.unverified);

      final target = HUser.fromFirebaseUser(firebaseUser);
      di.registerSingleton<HUserProxy>(HUserProxy(target));

      notifyListeners();
      return this;
    }

    await _handleSignIn(firebaseUser.uid);
    return this;
  }

  Future<void> _handleSignIn(String uid) async {
    try {
      final user = await _store.getUser(uid);

      if (!user.emailVerified) {
        if (di.hasScope(AuthScope.unverified)) {
          await di.dropScope(AuthScope.unverified);
        }

        di.pushNewScope(scopeName: AuthScope.unverified);
        di.registerSingleton<HUserProxy>(HUserProxy(user));
      } else {
        if (di.hasScope(AuthScope.authenticated)) {
          _log.info(
            'HAS SCOPE AUTHENTICATED ::: DROPPING "authenticated" SCOPE',
          );
          await di.dropScope(AuthScope.authenticated);
        }

        _log.info('AUTHENTICATED ::: PUSHING "authenticated" SCOPE');
        di.pushNewScope(scopeName: AuthScope.authenticated);
        di.registerSingleton<HUserProxy>(HUserProxy(user));
      }
    } on Exception catch (error) {
      _log.severe('ERROR FETCHING USER FROM DB, FORCING SIGN_OUT', error);

      await _auth.signOut();
      await _handleSignOut();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _handleSignUp(User firebaseUser) async {
    try {
      final user = HUser.fromFirebaseUser(firebaseUser);
      await _store.createUser(user);

      if (di.hasScope(AuthScope.unverified)) {
        await di.dropScope(AuthScope.unverified);
      }

      _log.info('UNVERIFIED ::: PUSHING "unverified" SCOPE');
      di.pushNewScope(scopeName: AuthScope.unverified);
      di.registerSingleton<HUserProxy>(HUserProxy(user));
    } on Exception catch (error) {
      _log.severe('ERROR FETCHING USER FROM DB, FORCING SIGN_OUT', error);

      await _auth.signOut();
      await _handleSignOut();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _handleSignOut() async {
    if (di.hasScope(AuthScope.unauthenticated)) {
      _log.info('UNAUTHENTICATED. POPPING SCOPE');
      await di.popScope();
    } else {
      _log.info('UNAUTHENTICATED. PUSHING "unauthenticated" SCOPE');
      di.pushNewScope(scopeName: AuthScope.unauthenticated);
      di.registerSingleton<HUserProxy>(.empty);
    }

    notifyListeners();
  }

  Future<bool?> _handleVerification(bool emailVerified) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return false;

      final userProxy = di<HUserProxy>();
      if (firebaseUser.emailVerified) {
        userProxy.update(emailVerified: emailVerified);
        await _store.updateUser(userProxy.target);

        if (di.hasScope(AuthScope.authenticated)) {
          await di.dropScope(AuthScope.authenticated);
        }

        di.pushNewScope(scopeName: AuthScope.authenticated);
        di.registerSingleton<HUserProxy>(userProxy);

        return true;
      } else {
        return false;
      }
    } on Exception catch (error) {
      _log.severe('Error checking verification', error);
      throw Exception('An error occurred while checking verification: $error');
    } finally {
      notifyListeners();
    }
  }
}
