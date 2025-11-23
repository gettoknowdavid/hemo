import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';

class SignUpPage extends WatchingStatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthManager _manager = di<AuthManager>();

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
    _manager.signUp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.signUp.isRunning);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const .all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Name'),
                controller: _nameController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Name is required';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Email'),
                controller: _emailController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  return null;
                },
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: isLoading ? null : onSignUpPressed,
                child: isLoading
                    ? const Text('Loading...')
                    : const Text('Sign Up'),
              ),
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
