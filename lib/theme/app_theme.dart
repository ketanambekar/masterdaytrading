import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    primaryColor: AppColors.lightPrimary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightCard,
      elevation: 0,
      foregroundColor: AppColors.lightText,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'cabin',
        fontSize: 16,
        color: AppColors.lightText,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'cabin',
        fontSize: 14,
        color: AppColors.lightText,
      ),
    ),
    fontFamily: 'cabin',
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightAccent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    primaryColor: AppColors.darkPrimary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkCard,
      elevation: 0,
      foregroundColor: AppColors.darkText,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'cabin',
        fontSize: 16,
        color: AppColors.darkText,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'cabin',
        fontSize: 14,
        color: AppColors.darkText,
      ),
    ),
    fontFamily: 'cabin',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkAccent,
    ),
  );
}
