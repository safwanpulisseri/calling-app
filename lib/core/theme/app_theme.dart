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
      displaySmall: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w800,
        fontSize: 23,
      ),
      headlineLarge: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      headlineMedium: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      headlineSmall: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 19,
      ),
      titleLarge: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleMedium: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 17,
      ),
      titleSmall: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      labelLarge: const TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
      labelMedium: const TextStyle(
        color: AppColor.secondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      labelSmall: const TextStyle(
        color: AppColor.secondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: const TextStyle(
        color: AppColor.secondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: const TextStyle(
        color: AppColor.secondary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: const TextStyle(
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
        minimumSize: const Size(double.infinity, 50),
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
