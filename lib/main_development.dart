import 'package:flutter/material.dart';
import 'package:hemo/app.dart';
import 'package:logging/logging.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
/// Uses local data.
void main() {
  Logger.root.level = Level.ALL;
  runApp(const HemoApp());
}
