import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';
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
    _manager.signIn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.signIn.isRunning);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const .all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: .onUserInteraction,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                controller: _emailController,
                enabled: !isLoading,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                controller: _passwordController,
                obscureText: true,
                enabled: !isLoading,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: isLoading ? null : onSignInPressed,
                child: isLoading
                    ? const Text('Loading...')
                    : const Text('Sign In'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.push(Routes.signUp),
                child: const Text('Sign Up'),
              ),
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
