import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/auth/_models/h_user.dart';
import 'package:hemo/_shared/ui/theme/theme.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_primary_button.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_secondary_button.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_text_button.dart';
import 'package:hemo/_shared/ui/ui/ui.dart';
import 'package:hemo/routing/routes.dart';

class EmailVerificationPage extends WatchingWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<AuthManager>();
    final user = di<HUserProxy>();

    final isChecking = watchValue(
      (AuthManager m) => m.checkVerification.isRunning,
    );

    final isResending = watchValue(
      (AuthManager m) => m.resendVerificationEmail.isRunning,
    );

    final inProgress = isChecking || isResending;

    registerHandler(
      select: (AuthManager m) => m.checkVerification.errors,
      handler: (context, error, _) {
        if (error == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.error.toString())),
        );
      },
    );

    registerHandler(
      select: (AuthManager m) => m.resendVerificationEmail.errors,
      handler: (context, error, _) {
        if (error == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.error.toString())),
        );
      },
    );

    registerHandler(
      select: (AuthManager m) => m.checkVerification,
      handler: (context, isVerified, _) {
        if (isVerified == null) return;
        // Show a different message based on the result.
        if (isVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your email has been verified! Redirecting...'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(Routes.home);
        } else {
          // This case is unlikely to happen with your current logic,
          // but it's good to handle it.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email not verified yet. Please check your inbox.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
    );

    registerHandler(
      select: (AuthManager m) => m.resendVerificationEmail,
      handler: (context, isSent, _) {
        if (isSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email resent!')),
          );
        }
      },
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) manager.signOut.run();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Email Verification')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              RichText(
                text: TextSpan(
                  style: HTextStyles.subtitle.copyWith(
                    color: HColors.onSurface,
                  ),
                  children: [
                    const TextSpan(
                      text: "We've sent a verification link to your email: ",
                    ),
                    TextSpan(
                      text: user.target.email,
                      style: HTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: '. Follow the link to verify your email address.',
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              HPrimaryButton(
                'Check Verification',
                isLoading: isChecking,
                enabled: !inProgress,
                onPressed: manager.checkVerification.run,
              ),
              16.verticalSpace,
              HOutlinedButton(
                'Resend Verification Email',
                isLoading: isResending,
                enabled: false,
                onPressed: manager.resendVerificationEmail.run,
              ),
              if (!context.canPop()) ...[
                32.verticalSpace,
                HTextButton(
                  'Go back',
                  icon: const Icon(Icons.chevron_left),
                  enabled: !inProgress,
                  onPressed: manager.signOut.run,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
