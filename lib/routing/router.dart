import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart' show di;
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/auth/_models/auth_scope.dart';
import 'package:hemo/_features/auth/email_verification/widgets/email_verification_page.dart';
import 'package:hemo/_features/auth/sign_in/widgets/sign_in_page.dart';
import 'package:hemo/_features/auth/sign_up/widgets/sign_up_page.dart';
import 'package:hemo/_features/home/widgets/home_page.dart';
import 'package:hemo/_features/onboarding/base/widgets/base_page.dart';
import 'package:hemo/routing/routes.dart';

GoRouter routerConfig() {
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final isPublicRoute = Routes.public.contains(state.matchedLocation);

    switch (di.currentScopeName) {
      case AuthScope.unauthenticated:
        if (!isPublicRoute) return Routes.signIn;
        return null;
      case AuthScope.unverified:
        return Routes.emailVerification;
      case AuthScope.authenticated:
        if (isPublicRoute) return Routes.home;
        return null;
      default:
        return Routes.loading;
    }
  }

  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    refreshListenable: di<AuthManager>(),
    redirect: redirect,
    routes: [
      GoRoute(
        path: Routes.loading,
        builder: (context, state) => const BasePage(),
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: Routes.emailVerification,
        builder: (context, state) => const EmailVerificationPage(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
