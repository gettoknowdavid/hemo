class Routes {
  const Routes._();

  static const base = '/';
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
}

extension RoutesX on String {
  /// Helper extension to be used for Route names in GoRouter.
  /// Intended for simple routes and usage.
  String get n => '_$this';
}
