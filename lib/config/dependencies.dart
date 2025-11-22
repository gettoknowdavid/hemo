import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/auth/_models/auth_scope.dart';
import 'package:hemo/_features/auth/_models/h_user.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';
import 'package:hemo/routing/router.dart';

Future<void> registerDependencies() async {
  di.pushNewScope(scopeName: AuthScope.unknown);
  di.registerSingleton<HUserProxy>(.empty);

  di.registerSingleton<FirebaseAuth>(.instance);
  di.registerSingleton<FirebaseFirestore>(.instance);

  di.registerSingleton<FirebaseAuthService>(
    FirebaseAuthService(di<FirebaseAuth>()),
  );
  di.registerSingleton<FirebaseFirestoreService>(
    FirebaseFirestoreService(di<FirebaseFirestore>()),
  );

  di.registerLazySingletonAsync<AuthManager>(
    () => AuthManager(
      auth: di<FirebaseAuthService>(),
      store: di<FirebaseFirestoreService>(),
    ).initialize(),
  );

  await di.isReady<AuthManager>();

  di.registerSingletonAsync(() async => routerConfig());

  await di.allReady();
}
