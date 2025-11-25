import 'dart:async';

import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_shared/services/shared_preferences_service.dart';

final class OnboardingManager implements Disposable {
  OnboardingManager(SharedPreferencesService prefs) : _prefs = prefs;

  final SharedPreferencesService _prefs;

  bool get hasSeenOnboarding => _prefs.hasKey('onboarding') ?? false;

  late final Command<void, bool> completeOnboarding = .createAsyncNoParam(
    () => _prefs.setBool('onboarding', value: true),
    initialValue: false,
  );

  @override
  FutureOr<dynamic> onDispose() {
    completeOnboarding.dispose();
  }
}
