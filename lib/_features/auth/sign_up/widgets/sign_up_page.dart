import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/auth/_widgets/auth_options_widget.dart';
import 'package:hemo/_features/auth/_widgets/auth_redirect_link.dart';
import 'package:hemo/_features/onboarding/_managers/onboarding_manager.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/theme/h_text_styles.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_primary_button.dart';
import 'package:hemo/_shared/ui/ui/input/h_text_field.dart';
import 'package:hemo/_shared/utils/validators.dart';
import 'package:hemo/routing/routes.dart';

class SignUpPage extends WatchingStatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthManager _manager = di<AuthManager>();
  final OnboardingManager _onboardingManager = di<OnboardingManager>();

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _manager.signUp.errors.listen((error, _) {
      if (error == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.error.toString())),
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.signUp.isRunning);

    registerHandler(
      select: (AuthManager m) => m.signUp,
      handler: (context, isSuccess, _) async {
        if (isSuccess) {
          _onboardingManager.completeOnboarding.run();
          _clearFields();
          await context.push(Routes.emailVerification);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              24.verticalSpace,
              Text(
                'Create an account',
                style: HTextStyles.pageTitle,
              ),
              12.verticalSpace,
              Text(
                'Create your account and fill in the form below to get started',
                style: HTextStyles.subtitle,
              ),
              24.verticalSpace,
              HTextField(
                label: 'Name',
                hint: 'Enter your name',
                controller: _nameController,
                enabled: !isLoading,
                validator: HValidators.name,
              ),
              16.verticalSpace,
              HTextField(
                label: 'Email',
                hint: 'Enter your email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                validator: HValidators.email,
              ),
              16.verticalSpace,
              HTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordController,
                isPassword: true,
                enabled: !isLoading,
                validator: HValidators.signUpPassword,
              ),
              32.verticalSpace,
              HPrimaryButton(
                'Sign Up',
                isLoading: isLoading,
                onPressed: onSignUpPressed,
              ),
              32.verticalSpace,
              Row(
                mainAxisAlignment: .center,
                spacing: 8.r,
                children: [
                  const Expanded(child: Divider()),
                  Text(
                    'or Sign in with',
                    style: HTextStyles.subtitle.copyWith(color: HColors.gray2),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              32.verticalSpace,
              const AuthOptionsWidget(),
              32.verticalSpace,
              const AuthRedirectionLink.signUp(),
            ],
          ),
        ),
      ),
    );
  }

  void onSignUpPressed() {
    if (_formKey.currentState?.validate() == false) return;
    _manager.signUp.run((
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
