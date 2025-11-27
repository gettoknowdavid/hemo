import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_models/h_user.dart';
import 'package:hemo/_shared/services/models/h_scope.dart';
import 'package:hemo/_shared/services/models/h_user.dart';
import 'package:hemo/_shared/services/params/auth_params.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';
import 'package:logging/logging.dart';

final class AuthManager with ChangeNotifier implements Disposable {
  AuthManager({
    required FirebaseAuthService auth,
    required FirebaseFirestoreService store,
  }) : _auth = auth,
       _store = store;

  final FirebaseAuthService _auth;
  final FirebaseFirestoreService _store;

  final _log = Logger('AUTH_MANAGER');

  late final Command<SignInParams, bool> signIn = .createAsync(
    (params) => _auth.signIn(params).then(_handleSignIn),
    initialValue: false,
  );

  late final Command<void, void> signOut = .createAsyncNoParamNoResult(
    () => _auth.signOut().whenComplete(_handleSignOut),
  );

  late final Command<SignUpParams, bool> signUp = .createAsync(
    (params) => _auth.signUp(params).then(_handleSignUp),
    initialValue: false,
  );

  late final Command<void, bool?> checkVerification = .createAsyncNoParam(
    () => _auth.checkEmailVerification().then(_handleVerification),
    initialValue: null,
  );

  late final Command<void, bool> resendVerificationEmail = .createAsyncNoParam(
    () => _auth.resendEmailVerification().then((_) => true),
    initialValue: false,
  );

  /// This holds the verification ID received from Firebase.
  /// It's a ValueNotifier so the UI can listen for when the code is sent.
  final verificationId = ValueNotifier<String?>(null);

  /// This holds the token needed to resend the verification code.
  final resendToken = ValueNotifier<int?>(null);

  late final Command<VerifyMobileParams, void> verifyPhoneNumber =
      .createAsyncNoResult(
        (params) async => _auth.verifyPhoneNumber(
          params.phoneNumber,
          forceResendingToken: resendToken.value,
          onVerificationCompleted: params.onVerificationCompleted,
          onVerificationFailed: params.onVerificationFailed,
          onCodeTimeout: params.onCodeTimeout,
          onCodeSent: (vId, rToken) {
            _log.info('Code sent. Verification ID: $vId');
            verificationId.value = vId;
            resendToken.value = rToken;
            params.onCodeSent(vId, rToken);
          },
        ),
      );

  /// Re-triggers the verifyPhoneNumber command using the stored phone number
  /// and token.
  late final Command<String, void> resendPhoneVerificationCode =
      Command.createAsyncNoResult(
        (phoneNumber) async => verifyPhoneNumber.run((
          phoneNumber: phoneNumber,
          onVerificationCompleted: (_) {},
          onVerificationFailed: (_) {},
          onCodeSent: (_, _) {},
          onCodeTimeout: (_) {},
        )),
      );

  late final Command<LinkMobileParams, bool> linkPhoneNumber = .createAsync(
    (params) async {
      await _auth.linkPhoneNumber(params);

      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return false;

      final userProxy = di<HUserProxy>();
      userProxy.update(phoneNumber: firebaseUser.phoneNumber);
      await _store.updateUser(userProxy.target);

      if (di.hasScope(HScope.authenticated)) {
        await di.dropScope(HScope.authenticated);
      }

      di.pushNewScope(scopeName: HScope.authenticated);
      di.registerSingleton<HUserProxy>(userProxy);

      notifyListeners();
      return true;
    },
    initialValue: false,
  );

  Future<AuthManager> initialize() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      await _handleSignOut();
      return this;
    }

    if (!firebaseUser.emailVerified) {
      if (di.hasScope(HScope.unverified)) {
        await di.dropScope(HScope.unverified);
      }

      di.pushNewScope(scopeName: HScope.unverified);
      final target = HUser.fromFirebaseUser(firebaseUser);
      di.registerSingleton<HUserProxy>(HUserProxy(target));

      notifyListeners();
      return this;
    }

    if (firebaseUser.emailVerified && firebaseUser.phoneNumber == null) {
      if (di.hasScope(HScope.noPhoneNumber)) {
        await di.dropScope(HScope.noPhoneNumber);
      }

      di.pushNewScope(scopeName: HScope.noPhoneNumber);
      final target = HUser.fromFirebaseUser(firebaseUser);
      di.registerSingleton<HUserProxy>(HUserProxy(target));

      notifyListeners();
      return this;
    }

    await _handleSignIn(firebaseUser.uid);
    return this;
  }

  Future<bool> _handleSignIn(String uid) async {
    try {
      final user = await _store.getUser(uid);

      if (!user.emailVerified) {
        if (di.hasScope(HScope.unverified)) {
          await di.dropScope(HScope.unverified);
        }

        di.pushNewScope(scopeName: HScope.unverified);
        di.registerSingleton<HUserProxy>(HUserProxy(user));
        return true;
      } else {
        final firebaseUser = _auth.currentUser!;
        if (firebaseUser.emailVerified && firebaseUser.phoneNumber == null) {
          if (di.hasScope(HScope.noPhoneNumber)) {
            await di.dropScope(HScope.noPhoneNumber);
          }

          di.pushNewScope(scopeName: HScope.noPhoneNumber);
          final target = HUser.fromFirebaseUser(firebaseUser);
          di.registerSingleton<HUserProxy>(HUserProxy(target));
          return true;
        } else {
          if (di.hasScope(HScope.authenticated)) {
            _log.info(
              'HAS SCOPE AUTHENTICATED ::: DROPPING "authenticated" SCOPE',
            );
            await di.dropScope(HScope.authenticated);
          }

          _log.info('AUTHENTICATED ::: PUSHING "authenticated" SCOPE');
          di.pushNewScope(scopeName: HScope.authenticated);
          di.registerSingleton<HUserProxy>(HUserProxy(user));
          return true;
        }
      }
    } on Exception catch (error) {
      _log.severe('ERROR FETCHING USER FROM DB, FORCING SIGN_OUT', error);

      await _auth.signOut();
      await _handleSignOut();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> _handleSignUp(User firebaseUser) async {
    try {
      final user = HUser.fromFirebaseUser(firebaseUser);
      await _store.createUser(user);

      _log.info('UNVERIFIED ::: PUSHING "unverified" SCOPE');
      if (di.hasScope(HScope.unverified)) await di.dropScope(HScope.unverified);
      di.pushNewScope(scopeName: HScope.unverified);
      di.registerSingleton<HUserProxy>(HUserProxy(user));
      return true;
    } on Exception catch (error) {
      _log.severe('ERROR FETCHING USER FROM DB, FORCING SIGN_OUT', error);

      await _auth.signOut();
      await _handleSignOut();
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _handleSignOut() async {
    if (di.hasScope(HScope.unauthenticated)) {
      _log.info('UNAUTHENTICATED. POPPING SCOPE');
      await di.popScope();
    } else {
      _log.info('UNAUTHENTICATED. PUSHING "unauthenticated" SCOPE');
      di.pushNewScope(scopeName: HScope.unauthenticated);
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

        if (di.hasScope(HScope.noPhoneNumber)) {
          await di.dropScope(HScope.noPhoneNumber);
        }

        di.pushNewScope(scopeName: HScope.noPhoneNumber);
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

  @override
  FutureOr<dynamic> onDispose() {
    signIn.dispose();
    signOut.dispose();
    signUp.dispose();
    checkVerification.dispose();
    resendVerificationEmail.dispose();
    verificationId.dispose();
    resendToken.dispose();
    verifyPhoneNumber.dispose();
    resendPhoneVerificationCode.dispose();
    linkPhoneNumber.dispose();
  }
}
