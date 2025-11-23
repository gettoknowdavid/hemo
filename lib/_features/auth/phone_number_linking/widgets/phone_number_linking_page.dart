import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/routing/routes.dart';
import 'package:intl_mobile_field/intl_mobile_field.dart';

class PhoneNumberLinkingPage extends WatchingStatefulWidget {
  const PhoneNumberLinkingPage({super.key});

  @override
  State<PhoneNumberLinkingPage> createState() => _PhoneNumberLinkingPageState();
}

class _PhoneNumberLinkingPageState extends State<PhoneNumberLinkingPage> {
  final AuthManager _manager = di<AuthManager>();

  final _formKey = GlobalKey<FormState>();

  String? _completePhoneNumber;
  bool isSending = false;

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
            'phoneNumber': _completePhoneNumber,
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
        appBar: AppBar(title: const Text('Phone Number Verification')),
        body: SingleChildScrollView(
          padding: const .all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                IntlMobileField(
                  initialCountryCode: 'NG',
                  languageCode: 'en',
                  enabled: !isInProgress,
                  onChanged: (value) => setState(
                    () => _completePhoneNumber = value.completeNumber,
                  ),
                  dropdownIcon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  dropdownIconPosition: Position.trailing,
                  flagsButtonMargin: const .only(right: 10),
                  disableLengthCounter: true,
                  showFieldCountryFlag: false,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  validator: (mobileNumber) {
                    if (mobileNumber == null || mobileNumber.number.isEmpty) {
                      return 'Please enter a mobile number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(mobileNumber.number)) {
                      return 'Only digits are allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: isInProgress ? null : sendVerificationCode,
                  child: isInProgress
                      ? const Text('Sending...')
                      : const Text('Send code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendVerificationCode() {
    if (_completePhoneNumber != null) {
      setState(() => isSending = true);

      _manager.verifyPhoneNumber.run((
        phoneNumber: _completePhoneNumber!,
        onCodeSent: (id, token) {},
        onVerificationFailed: (error) {},
        onCodeTimeout: (id) {},
        onVerificationCompleted: (credential) {},
      ));
    }
  }
}
