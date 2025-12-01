import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/theme/h_text_styles.dart';
import 'package:hemo/_shared/ui/theme/page_transitions.dart';

final _inputDecorationTheme = InputDecorationThemeData(
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
  hintStyle: TextStyle(
    color: HColors.gray2,
    fontFamily: HTextStyles.fontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    height: (18 / 13).h,
    letterSpacing: -0.02.w,
  ),
  contentPadding: const EdgeInsets.fromLTRB(10, 14, 10, 14).r,
  isDense: true,
  visualDensity: VisualDensity.compact,
  prefixIconConstraints: const BoxConstraints(maxHeight: 32).r,
  suffixIconConstraints: const BoxConstraints(maxHeight: 32).r,
);

final class HTheme {
  static ThemeData get theme => ThemeData(
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (_) => IconTheme(
        data: IconThemeData(color: HColors.onSurface, size: 18.sp),
        child: const Icon(Icons.arrow_back_ios),
      ),
    ),
    appBarTheme: AppBarTheme(
      data: AppBarThemeData(
        // backgroundColor: HColors.surface,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: HColors.onSurface,
          fontSize: 18.sp,
          fontFamily: HTextStyles.fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      showDragHandle: true,
      shape: const RoundedRectangleBorder(),
      constraints: BoxConstraints(maxHeight: 0.9.sh),
    ),
    colorScheme: const ColorScheme.light(primary: HColors.primary),
    dividerTheme: const DividerThemeData(color: HColors.gray3),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        elevation: const WidgetStatePropertyAll(0),
        padding: WidgetStatePropertyAll(const EdgeInsets.only(right: 1).r),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(.circular(8)).r,
            side: BorderSide(width: 1.w, color: HColors.gray3),
          ),
        ),
      ),
      textStyle: TextStyle(
        fontFamily: HTextStyles.fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: HColors.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(data: _inputDecorationTheme),
    ),
    fontFamily: HTextStyles.fontFamily,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: HColors.primary,
        textStyle: HTextStyles.button,
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
    inputDecorationTheme: InputDecorationTheme(data: _inputDecorationTheme),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        textStyle: HTextStyles.button,
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
    searchBarTheme: SearchBarThemeData(
      constraints: const BoxConstraints(maxHeight: 56, minHeight: 40).r,
      padding: WidgetStatePropertyAll(
        const EdgeInsets.symmetric(horizontal: 8).r,
      ),
      backgroundColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return HColors.gray3;
        return Colors.white;
      }),
      hintStyle: WidgetStatePropertyAll(
        TextStyle(
          color: HColors.gray2,
          fontFamily: HTextStyles.fontFamily,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.02.w,
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          color: HColors.onSurface,
          fontFamily: HTextStyles.fontFamily,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevation: const WidgetStatePropertyAll(0),
      shape: WidgetStateOutlinedBorder.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(.circular(6)).r,
            side: BorderSide(color: HColors.primary, width: 2.w),
          );
        }

        return RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(.circular(6)).r,
          side: BorderSide(color: HColors.gray3, width: 1.w),
        );
      }),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HColors.onSurface,
        textStyle: HTextStyles.button.copyWith(fontWeight: .w500),
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
