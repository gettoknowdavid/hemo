import 'package:flutter/material.dart';
import 'package:hemo/app.dart';
import 'package:logging/logging.dart';

/// Production config entry point.
/// Launch with `flutter run --target lib/main_production.dart`.
/// Uses remote data for production.
void main() {
  Logger.root.level = Level.ALL;
  runApp(const HemoApp());
}
