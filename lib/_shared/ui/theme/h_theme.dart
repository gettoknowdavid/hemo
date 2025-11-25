import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/theme/h_text_styles.dart';
import 'package:hemo/_shared/ui/theme/page_transitions.dart';

final class HTheme {
  static ThemeData get theme => ThemeData(
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) => IconTheme(
        data: IconThemeData(color: HColors.onSurface, size: 18.sp),
        child: const Icon(Icons.arrow_back_ios),
      ),
    ),
    colorScheme: const ColorScheme.light(primary: HColors.primary),
    fontFamily: HTextStyles.fontFamily,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: HTextStyles.label,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8).r,
        tapTargetSize: .shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(.circular(8)).r,
        ),
      ),
    ),
    pageTransitionsTheme: HPageTransitions.theme,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HColors.onSurface,
        textStyle: HTextStyles.label.copyWith(fontWeight: .w500),
        padding: .zero,
        tapTargetSize: .shrinkWrap,
        visualDensity: .compact,
        minimumSize: .zero,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(.circular(2)).r,
        ),
      ),
    ),
  );
}
