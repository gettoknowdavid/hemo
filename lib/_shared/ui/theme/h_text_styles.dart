/// The **2021** spec has fifteen text styles:
///
/// | NAME           | SIZE |  HEIGHT |  WEIGHT |  SPACING |             |
/// |----------------|------|---------|---------|----------|-------------|
/// | displayLarge   | 57.0 |   64.0  | regular | -0.25    |             |
/// | displayMedium  | 45.0 |   52.0  | regular |  0.0     |             |
/// | displaySmall   | 36.0 |   44.0  | regular |  0.0     |             |
/// | headlineLarge  | 32.0 |   40.0  | regular |  0.0     |             |
/// | headlineMedium | 28.0 |   36.0  | regular |  0.0     |             |
/// | headlineSmall  | 24.0 |   32.0  | regular |  0.0     |             |
/// | titleLarge     | 22.0 |   28.0  | regular |  0.0     |             |
/// | titleMedium    | 16.0 |   24.0  | medium  |  0.15    |             |
/// | titleSmall     | 14.0 |   20.0  | medium  |  0.1     |             |
/// | bodyLarge      | 16.0 |   24.0  | regular |  0.5     |             |
/// | bodyMedium     | 14.0 |   20.0  | regular |  0.25    |             |
/// | bodySmall      | 12.0 |   16.0  | regular |  0.4     |             |
/// | labelLarge     | 14.0 |   20.0  | medium  |  0.1     |             |
/// | labelMedium    | 12.0 |   16.0  | medium  |  0.5     |             |
/// | labelSmall     | 11.0 |   16.0  | medium  |  0.5     |             |
///
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class HTextStyles {
  const HTextStyles._();

  static const String fontFamily = 'Manrope';

  static final TextStyle headlineBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    height: (32 / 24).h,
    fontFamily: fontFamily,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    height: (24 / 16).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    height: (20 / 14).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    height: (16 / 12).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle title = TextStyle(
    fontSize: 22.sp,
    height: (28 / 22).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle pageTitle = TextStyle(
    fontSize: 22.sp,
    height: (28 / 22).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.05.sp,
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: 13.sp,
    height: (18 / 13).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle button = TextStyle(
    fontSize: 14.sp,
    height: (20 / 14).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle label = TextStyle(
    fontSize: 13.sp,
    height: (18 / 13).h,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );
}
