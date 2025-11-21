import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_shared/services/remote/firebase_auth_service.dart';
import 'package:hemo/_shared/services/remote/firebase_firestore_service.dart';
import 'package:logging/logging.dart';

void registerDependencies() {
  di.registerFactoryParam<Logger, String, dynamic>((name, _) => Logger(name));

  di.registerSingleton<FirebaseAuth>(.instance);
  di.registerSingleton<FirebaseFirestore>(.instance);

  di.registerSingleton<FirebaseAuthService>(
    FirebaseAuthService(auth: di<FirebaseAuth>()),
  );
  di.registerSingleton<FirebaseFirestoreService>(
    FirebaseFirestoreService(store: di<FirebaseFirestore>()),
  );

  di.registerSingleton<AuthManager>(
    AuthManager(
      auth: di<FirebaseAuthService>(),
      store: di<FirebaseFirestoreService>(),
    ),
  );
}
