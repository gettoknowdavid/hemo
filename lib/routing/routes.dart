class Routes {
  const Routes._();

  static const List<String> public = [
    Routes.loading,
    Routes.onboarding,
    Routes.signIn,
    Routes.signUp,
  ];

  static const loading = '/loading';
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const emailVerification = '/email-verification';
  static const phoneNumberLinking = '/phone-number-linking';
  static const phoneNumberVerification = '$phoneNumberLinking/verification';
  static const home = '/';
}

extension RoutesX on String {
  /// Helper extension to be used for Route names in GoRouter.
  /// Intended for simple routes and usage.
  String get n => '_$this';
}
