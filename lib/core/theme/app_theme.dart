import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: AppColor.background,
    textTheme:  TextTheme(
      displayLarge:  GoogleFonts.inter(
                       textStyle: const TextStyle(
                       color: AppColor.background,
                       fontSize: 20,
                      fontWeight: FontWeight.w800,
                       ),
                      ),
      displayMedium:GoogleFonts.nunito(
                       textStyle: const TextStyle(
                       color: AppColor.background,
                       fontSize: 16,
                      fontWeight: FontWeight.w700,
                       ),
                      ),
      displaySmall: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w800,
        fontSize: 23,
      ),
      headlineLarge: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      headlineMedium: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      headlineSmall: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 19,
      ),
      titleLarge: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ),
      titleSmall: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      labelLarge: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      labelMedium: TextStyle(
        color: AppColor.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: TextStyle(
        color: AppColor.secondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColor.secondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: AppColor.secondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.background,
    ),
    tabBarTheme: const TabBarTheme(dividerColor: Colors.transparent),
    appBarTheme: const AppBarTheme(backgroundColor: AppColor.background),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColor.background,
      titleTextStyle: const TextStyle(
        color: AppColor.secondary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: AppColor.secondary,
        fontSize: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
