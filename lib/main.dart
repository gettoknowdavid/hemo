import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hemo/config/dependencies.dart';
import 'package:hemo/firebase_options.dart';
import 'package:hemo/main_development.dart' as dev;

/// Entry point for the app.
Future<void> main() async {
  // Initialize Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  // Did not want to create another Firebase project for staging or production,
  // so this will do for now.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register dependencies.
  await registerDependencies();

  // Launch the development config by default.
  dev.main();
}
