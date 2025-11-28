import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_shared/ui/theme/theme.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_primary_button.dart';
import 'package:hemo/_shared/ui/ui/input/h_phone_number_field.dart';
import 'package:hemo/_shared/utils/validators.dart';
import 'package:hemo/routing/routes.dart';

class PhoneNumberLinkingPage extends WatchingStatefulWidget {
  const PhoneNumberLinkingPage({super.key});

  @override
  State<PhoneNumberLinkingPage> createState() => _PhoneNumberLinkingPageState();
}

class _PhoneNumberLinkingPageState extends State<PhoneNumberLinkingPage> {
  final AuthManager _manager = di<AuthManager>();

  final _formKey = GlobalKey<FormState>();

  String? _phoneNumber;
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    final isCommandRunning = watchValue(
      (AuthManager m) => m.verifyPhoneNumber.isRunning,
    );

    final isInProgress = isCommandRunning || isSending;

    registerHandler(
      select: (AuthManager m) => m.verificationId,
      handler: (context, value, cancel) async {
        if (value == null) return;
        setState(() => isSending = false);
        await context.pushNamed(
          Routes.phoneNumberVerification,
          queryParameters: {
            'verificationId': value,
            'phoneNumber': _phoneNumber,
          },
        );
      },
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final result = await showDialog<bool?>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure you want to sign out?'),
            content: const Text(
              '''
You will have to sign in again to verify your phone number before you can continue''',
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: const Text('Sign Out'),
              ),
            ],
          ),
        );
        if (result ?? false) _manager.signOut.run();
      },
      child: Scaffold(
        appBar: AppBar(),
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
                        Text(
                          'Add your Phone Number',
                          style: HTextStyles.title.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.05.sp,
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          '''
To secure your account, please provide a valid mobile number. We'll send a one-time verification code to confirm you're the owner.''',
                          style: HTextStyles.subtitle,
                        ),
                        24.verticalSpace,
                        HPhoneNumberField(
                          label: 'Mobile Number',
                          hint: 'Enter your mobile number',
                          enabled: !isInProgress,
                          onChanged: (v) =>
                              setState(() => _phoneNumber = v.phoneNumber),
                          validator: HValidators.phoneNumber,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              HPrimaryButton(
                'Send code',
                isLoading: isInProgress,
                enabled: !isInProgress,
                onPressed: sendVerificationCode,
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void sendVerificationCode() {
    if (_phoneNumber != null) {
      setState(() => isSending = true);

      _manager.verifyPhoneNumber.run((
        phoneNumber: _phoneNumber!,
        onCodeSent: (id, token) {},
        onVerificationFailed: (error) {},
        onCodeTimeout: (id) {},
        onVerificationCompleted: (credential) {},
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    // Listen errors on the verify phone number command
    _manager.verifyPhoneNumber.errors.listen((error, _) {
      if (error == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send code: ${error.error}')),
      );
    });
  }

  @override
  void dispose() {
    _manager.verifyPhoneNumber.dispose();
    super.dispose();
  }
}
