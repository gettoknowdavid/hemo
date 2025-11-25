import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/onboarding/widgets/base_page.dart';
import 'package:hemo/_shared/ui/theme/h_theme.dart';

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

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: di<GoRouter>(),
        theme: HTheme.theme,
        builder: (context, child) {
          final defaultTextScaler = MediaQuery.textScalerOf(context);
          final textScaler = defaultTextScaler.clamp(
            minScaleFactor: 0.85.sp,
            maxScaleFactor: 1.sp,
          );

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          );
        },
      ),
    );
  }
}
