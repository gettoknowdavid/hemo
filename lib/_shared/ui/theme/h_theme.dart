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
    appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 0),
    colorScheme: const ColorScheme.light(primary: HColors.primary),
    dividerTheme: const DividerThemeData(color: HColors.gray3),
    fontFamily: HTextStyles.fontFamily,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: HColors.primary,
        textStyle: HTextStyles.label,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8).r,
        tapTargetSize: .shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(.circular(8)).r,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        padding: .zero,
        tapTargetSize: .shrinkWrap,
        visualDensity: .compact,
        minimumSize: .zero,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: WidgetStateInputBorder.resolveWith(
        (states) {
          final defaultBorder = OutlineInputBorder(
            borderRadius: const BorderRadius.all(.circular(6)).r,
            borderSide: BorderSide(color: HColors.gray3, width: 1.w),
          );

          if (states.contains(WidgetState.focused)) {
            return defaultBorder.copyWith(
              borderSide: BorderSide(color: HColors.primary, width: 2.w),
            );
          }

          return defaultBorder;
        },
      ),
      filled: true,
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return HColors.gray3;
        return Colors.white;
      }),
      contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10).r,
      hintStyle: TextStyle(
        color: HColors.gray2,
        fontFamily: HTextStyles.fontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: (18 / 13).h,
        letterSpacing: -0.02.w,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        textStyle: HTextStyles.label,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8).r,
        tapTargetSize: .shrinkWrap,
        side: BorderSide(
          color: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return HColors.gray3;
            return HColors.primary;
          }),
          width: 2.w,
        ),
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
