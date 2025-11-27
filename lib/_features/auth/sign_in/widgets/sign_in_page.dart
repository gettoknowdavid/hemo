import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
import 'package:hemo/_features/auth/_widgets/auth_options_widget.dart';
import 'package:hemo/_features/auth/_widgets/auth_redirect_link.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/theme/h_text_styles.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_primary_button.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_text_button.dart';
import 'package:hemo/_shared/ui/ui/input/h_text_field.dart';
import 'package:hemo/_shared/utils/validators.dart';
import 'package:hemo/routing/routes.dart';

class SignInPage extends WatchingStatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInnPageState();
}

class _SignInnPageState extends State<SignInPage> {
  final AuthManager _manager = di<AuthManager>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _manager.signIn.errors.listen((error, _) {
      if (error == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.error.toString())),
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.signIn.isRunning);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: Form(
          key: _formKey,
          autovalidateMode: .onUserInteraction,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              24.verticalSpace,
              Text(
                'Welcome to Hemo!',
                style: HTextStyles.title.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.05.sp,
                ),
              ),
              12.verticalSpace,
              Text(
                'Enter your email address and password to sign in',
                style: HTextStyles.subtitle,
              ),
              24.verticalSpace,
              HTextField(
                label: 'Email',
                hint: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
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
                validator: HValidators.signInPassword,
              ),
              12.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: HTextButton(
                  'Forgot Password?',
                  onPressed: () => context.push(Routes.forgotPassword),
                ),
              ),
              32.verticalSpace,
              HPrimaryButton(
                'Sign In',
                isLoading: isLoading,
                onPressed: onSignInPressed,
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
              const AuthRedirectionLink.signIn(),
            ],
          ),
        ),
      ),
    );
  }

  void onSignInPressed() {
    if (_formKey.currentState?.validate() == false) return;
    _manager.signIn.run((
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
