import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_shared/ui/theme/theme.dart';
import 'package:hemo/routing/routes.dart';

class AuthRedirectionLink extends StatelessWidget {
  const AuthRedirectionLink._(this.isSignIn);

  const AuthRedirectionLink.signIn() : this._(true);

  const AuthRedirectionLink.signUp() : this._(false);

  final bool isSignIn;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: HTextStyles.subtitle.copyWith(color: HColors.onSurface),
      child: Row(
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        children: [
          if (isSignIn)
            const Text('Don’t have an account?')
          else
            const Text('Already have an account?'),
          4.horizontalSpace,
          InkWell(
            onTap: () => isSignIn ? context.push(Routes.signUp) : context.pop(),
            child: Text(
              isSignIn ? 'Sign up' : 'Sign in',
              style: HTextStyles.subtitle.copyWith(color: HColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
