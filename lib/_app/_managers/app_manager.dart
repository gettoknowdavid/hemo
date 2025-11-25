import 'package:flutter/foundation.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/onboarding/_managers/onboarding_manager.dart';
import 'package:hemo/_shared/services/models/h_scope.dart';

final class AppManager with ChangeNotifier {
  AppManager({
    required OnboardingManager onboarding,
    required AuthManager auth,
  }) : _onboarding = onboarding,
       _auth = auth;

  final OnboardingManager _onboarding;
  final AuthManager _auth;

  Future<AppManager> initialize() async {
    if (!_onboarding.hasSeenOnboarding) {
      if (di.hasScope(HScope.onboarding)) await di.dropScope(HScope.onboarding);
      di.pushNewScope(scopeName: HScope.onboarding);
    } else {
      await _auth.initialize();
    }
    notifyListeners();
    return this;
  }
}
