import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/onboarding/base/widgets/base_page.dart';

class HemoApp extends WatchingWidget {
  const HemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wait for all dependencies to be ready
    if (!allReady()) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BasePage(),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: di<GoRouter>(),
    );
  }
}
