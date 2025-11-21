import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';

class LoginPage extends WatchingStatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(controller: _emailController),
            const SizedBox(height: 20),
            TextFormField(controller: _passwordController, obscureText: true),
            const SizedBox(height: 30),
            FilledButton(
              onPressed: () {},
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
