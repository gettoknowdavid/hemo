import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart' show di;
import 'package:go_router/go_router.dart';
import 'package:hemo/_app/_managers/app_manager.dart';
import 'package:hemo/_features/auth/email_verification/widgets/email_verification_page.dart';
import 'package:hemo/_features/auth/phone_number_linking/widgets/phone_number_linking_page.dart';
import 'package:hemo/_features/auth/phone_number_linking/widgets/phone_verification_page.dart';
import 'package:hemo/_features/auth/sign_in/widgets/sign_in_page.dart';
import 'package:hemo/_features/auth/sign_up/widgets/sign_up_page.dart';
import 'package:hemo/_features/home/widgets/home_page.dart';
import 'package:hemo/_features/onboarding/widgets/base_page.dart';
import 'package:hemo/_features/onboarding/widgets/onboarding_page.dart';
import 'package:hemo/_features/profile/personal_information/widgets/basic_information_page.dart';
import 'package:hemo/_features/profile/personal_information/widgets/personal_information_page.dart';
import 'package:hemo/_shared/services/models/h_scope.dart';
import 'package:hemo/routing/routes.dart';

GoRouter routerConfig() {
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final nextRoute = state.matchedLocation;
    final isPublicRoute = Routes.public.contains(nextRoute);

    switch (di.currentScopeName) {
      case HScope.onboarding:
        if (!isPublicRoute) return Routes.onboarding;
        return null;
      case HScope.unauthenticated:
        if (!isPublicRoute) return Routes.signIn;
        return null;
      case HScope.unverified:
        return Routes.emailVerification;
      case HScope.noPhoneNumber:
        if (Routes.phoneNumberVerification == nextRoute) return null;
        return Routes.phoneNumberLinking;
      case HScope.personalInfo:
        if (Routes.basicInfo == nextRoute) return null;
        return Routes.personalInfo;
      case HScope.authenticated:
        if (isPublicRoute) return Routes.home;
        return null;
      default:
        return Routes.loading;
    }
  }

  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    refreshListenable: di<AppManager>(),
    redirect: redirect,
    routes: [
      GoRoute(
        path: Routes.loading,
        builder: (context, state) => const BasePage(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingPage(),
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
        path: Routes.phoneNumberLinking,
        builder: (context, state) => const PhoneNumberLinkingPage(),
        routes: [
          GoRoute(
            path: 'verification',
            name: Routes.phoneNumberVerification,
            builder: (context, state) => PhoneVerificationPage(
              verificationId: state.uri.queryParameters['verificationId']!,
              phoneNumber: state.uri.queryParameters['phoneNumber']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.personalInfo,
        builder: (context, state) => const PersonalInformationPage(),
      ),
      GoRoute(
        path: Routes.basicInfo,
        builder: (context, state) => const BasicInformationPage(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
