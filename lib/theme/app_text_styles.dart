import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle headline(BuildContext context) => TextStyle(
    fontFamily: 'cabin',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  static TextStyle subtitle(BuildContext context) => TextStyle(
    fontFamily: 'cabin',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.bodyMedium?.color,
  );

  static TextStyle decorative() => const TextStyle(
    fontFamily: 'windSong',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.lightAccent, // overrides if needed
  );
}
