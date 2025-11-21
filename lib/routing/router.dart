import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart' show di;
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/auth/_models/auth_scope.dart';
import 'package:hemo/_features/auth/login/widgets/login_page.dart';
import 'package:hemo/_features/home/widgets/home_page.dart';
import 'package:hemo/_features/onboarding/base/widgets/base_page.dart';
import 'package:hemo/routing/routes.dart';

GoRouter routerConfig() {
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final scope = di.currentScopeName;

    final nextRoute = state.matchedLocation;

    final publicRoutes = [Routes.base, Routes.login];
    final isPublicRoute = publicRoutes.contains(nextRoute);

    switch (scope) {
      case AuthScope.unauthenticated:
        if (!isPublicRoute) return Routes.login;
        return null;
      case AuthScope.authenticated:
        if (isPublicRoute) return Routes.home;
        return null;
      default:
        return Routes.base;
    }
  }

  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    refreshListenable: di<AuthManager>(),
    redirect: redirect,
    routes: [
      GoRoute(
        path: Routes.base,
        builder: (context, state) => const BasePage(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
