import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/routing/routes.dart';

class EmailVerificationPage extends WatchingWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<AuthManager>();

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
        appBar: AppBar(title: const Text('Verification')),
        body: SingleChildScrollView(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              FilledButton(
                onPressed: inProgress ? null : manager.checkVerification.run,
                child: isChecking
                    ? const Text('Checking...')
                    : const Text('Check Verification'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: inProgress
                    ? null
                    : manager.resendVerificationEmail.run,
                child: isResending
                    ? const Text('Resending...')
                    : const Text('Resend Verification Email'),
              ),
              if (!context.canPop()) ...[
                TextButton(
                  onPressed: inProgress ? null : manager.signOut.run,
                  child: const Text('Go back'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
