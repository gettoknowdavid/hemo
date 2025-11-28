import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_shared/ui/ui.dart';
import 'package:hemo/routing/routes.dart';

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

  @override
  Widget build(BuildContext context) {
    final isVerifying = watchValue(
      (AuthManager m) => m.linkPhoneNumber.isRunning,
    );

    final isResending = watchValue(
      (AuthManager m) => m.resendPhoneVerificationCode.isRunning,
    );

    final isInProgress = isVerifying || isResending;

    registerHandler(
      select: (AuthManager m) => m.linkPhoneNumber,
      handler: (context, verified, cancel) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number link successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go(Routes.home);
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verification Code')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            20.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: HTextStyles.bodyLarge.copyWith(
                            color: HColors.onSurface,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  '''Please enter the verification code we sent to your mobile number: ''',
                            ),
                            TextSpan(
                              text: widget.phoneNumber,
                              style: HTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      48.verticalSpace,
                      HPinField(
                        autofocus: true,
                        enabled: !isVerifying,
                        controller: _otpController,
                        onCompleted: (_) => FocusScope.of(context).unfocus(),
                        validator: (i) {
                          if (i == null || i.isEmpty) return 'Code is required';
                          return null;
                        },
                      ),
                      24.verticalSpace,
                      if (_countdown > 0)
                        Text(
                          '''Resend code in 00:${_countdown.toString().padLeft(2, '0')}''',
                          textAlign: TextAlign.center,
                          style: HTextStyles.bodyLarge.copyWith(
                            color: HColors.gray2,
                            letterSpacing: -0.25.w,
                          ),
                        )
                      else
                        DefaultTextStyle(
                          style: HTextStyles.bodyLarge.copyWith(
                            color: HColors.onSurface,
                          ),
                          child: Row(
                            mainAxisAlignment: .center,
                            mainAxisSize: .min,
                            children: [
                              const Text("Didn't get the code?"),
                              4.horizontalSpace,
                              InkWell(
                                onTap: isInProgress ? null : resendCode,
                                child: Text(
                                  'Resend Code',
                                  style: HTextStyles.bodyLarge.copyWith(
                                    color: HColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            HPrimaryButton(
              'Verify',
              isLoading: isVerifying,
              enabled: !isInProgress,
              onPressed: linkPhoneNumber,
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  void linkPhoneNumber() {
    if (_formKey.currentState?.validate() == false) return;
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
    super.dispose();
  }
}
