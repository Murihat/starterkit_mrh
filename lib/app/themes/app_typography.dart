import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTypography {
  AppTypography._();

  /// Ganti nama font utama di sini untuk mengubah seluruh aplikasi
  static const String fontFamily = 'OpenSans';

  // ===========================================================================
  // FONT SIZES (RESPONSIVE DENGAN SCREENUTIL)
  // ===========================================================================
  static double get xs => 12.sp;
  static double get sm => 14.sp;
  static double get md => 16.sp;
  static double get lg => 18.sp;
  static double get xl => 20.sp;
  static double get xxl => 24.sp;
  static double get display => 32.sp;

  // ===========================================================================
  // FONT WEIGHTS
  // ===========================================================================
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ===========================================================================
  // MATERIAL 3 TEXT THEME GENERATOR
  // ===========================================================================
  static TextTheme createTextTheme(Color defaultTextColor) {
    return TextTheme(
      // Display / Headline Besar
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: display,
        fontWeight: bold,
        color: defaultTextColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: xxl,
        fontWeight: bold,
        color: defaultTextColor,
      ),

      // Titles (AppBar, Card Header, Section Header)
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: xl,
        fontWeight: bold,
        color: defaultTextColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: lg,
        fontWeight: semiBold,
        color: defaultTextColor,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: md,
        fontWeight: semiBold,
        color: defaultTextColor,
      ),

      // Body (Paragraf, Teks utama)
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: md,
        fontWeight: regular,
        color: defaultTextColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: sm,
        fontWeight: regular,
        color: defaultTextColor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: xs,
        fontWeight: regular,
        color: defaultTextColor.withValues(alpha: 0.7),
      ),

      // Labels (Button text, Badge, Tag, Subtitle halus)
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: sm,
        fontWeight: semiBold,
        color: defaultTextColor,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: xs,
        fontWeight: medium,
        color: defaultTextColor,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10.sp,
        fontWeight: medium,
        color: defaultTextColor.withValues(alpha: 0.6),
      ),
    );
  }
}
