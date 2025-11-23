import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/routing/routes.dart';
import 'package:pinput/pinput.dart';

class PhoneVerificationPage extends WatchingStatefulWidget {
  const PhoneVerificationPage({
    required this.verificationId,
    required this.phoneNumber,
    super.key,
  });

  final String verificationId;
  final String phoneNumber;

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final AuthManager _manager = di<AuthManager>();

  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();

  Timer? _timer;
  int _countdown = 60;

  void startTimer() {
    _countdown = 60;

    // Cancel any existing timer
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();

    // Listen errors on the verify phone number command
    _manager.resendPhoneVerificationCode.errors.listen((error, _) {
      if (error == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend code: ${error.error}')),
      );
    });

    // Listen errors on the link phone number command
    _manager.linkPhoneNumber.errors.listen((error, _) {
      if (error == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to link number: ${error.error}')),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _manager.resendPhoneVerificationCode.dispose();
    _manager.linkPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVerifying = watchValue(
      (AuthManager m) => m.linkPhoneNumber.isRunning,
    );

    final isResending = watchValue(
      (AuthManager m) => m.resendPhoneVerificationCode.isRunning,
    );

    final isInProgress = isVerifying || isResending;

    void linkPhoneNumber() {
      if (_otpController.text.isEmpty) return;
      _manager.linkPhoneNumber.run((
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      ));
    }

    void resendCode() {
      _manager.resendPhoneVerificationCode.run(widget.phoneNumber);
      startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A new code has been sent.')),
      );
    }

    registerHandler(
      select: (AuthManager m) => m.linkPhoneNumber,
      handler: (context, verified, cancel) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number link successfully! Redirecting...'),
            backgroundColor: Colors.green,
          ),
        );
        context.go(Routes.home);
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verification Code')),
      body: SingleChildScrollView(
        padding: const .all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Pinput(
                length: 6,
                enabled: !isVerifying,
                controller: _otpController,
                onCompleted: (_) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 30),
              if (_countdown > 0)
                Text(
                  'Resend code in 00:${_countdown.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                )
              else
                TextButton(
                  onPressed: isInProgress ? null : resendCode,
                  child: isResending
                      ? const Text('Resending...')
                      : const Text('Resend Code'),
                ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: isInProgress ? null : linkPhoneNumber,
                child: isVerifying
                    ? const Text('Verifying...')
                    : const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
