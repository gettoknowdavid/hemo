import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:hemo/_features/auth/_managers/auth_manager.dart';

class HomePage extends WatchingWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<AuthManager>();
    final isLoading = watchValue((AuthManager m) => m.signOut.isRunning);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        padding: const .all(16),
        child: Center(
          child: Column(
            children: [
              FilledButton(
                onPressed: isLoading ? null : manager.signOut.run,
                child: isLoading
                    ? const Text('Loading...')
                    : const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
