import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hemo/_app/_managers/app_manager.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/auth/_models/h_user.dart';
import 'package:hemo/_features/onboarding/_managers/onboarding_manager.dart';
import 'package:hemo/_shared/services/models/h_scope.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';
import 'package:hemo/_shared/services/shared_preferences_service.dart';
import 'package:hemo/routing/router.dart';

Future<void> registerDependencies() async {
  di.pushNewScope(scopeName: HScope.unknown);
  di.registerSingleton<HUserProxy>(.empty);

  //
  // Third-party services
  //
  di.registerLazySingletonAsync(SharedPreferencesService.initialize);
  await di.isReady<SharedPreferencesService>();

  di.registerSingleton<FirebaseAuth>(.instance);
  di.registerSingleton<FirebaseFirestore>(.instance);

  di.registerSingleton(FirebaseAuthService(di<FirebaseAuth>()));
  di.registerSingleton(FirebaseFirestoreService(di<FirebaseFirestore>()));

  //
  // Managers
  //
  di.registerSingleton(OnboardingManager(di<SharedPreferencesService>()));

  di.registerLazySingleton<AuthManager>(
    () => AuthManager(
      auth: di<FirebaseAuthService>(),
      store: di<FirebaseFirestoreService>(),
    ),
  );

  di.registerLazySingletonAsync<AppManager>(
    () => AppManager(
      auth: di<AuthManager>(),
      onboarding: di<OnboardingManager>(),
    ).initialize(),
  );

  await di.isReady<AppManager>();

  di.registerSingletonAsync(() async => routerConfig());

  await di.allReady();

  FlutterNativeSplash.remove();
}
