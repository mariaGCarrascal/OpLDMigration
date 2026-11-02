import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/theme/app_theme_extesion.dart';

class DarkTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.background,
      secondary: AppColors.activeColor,
      surface: AppColors.surface,
      onPrimary: AppColors.textColor1,
      onSecondary: AppColors.textColor2,
      onSurface: AppColors.textColor3,
      error: AppColors.error,
      onError: AppColors.error,
    ),
//#2A2A2A
    extensions: [
      AppThemeExtension(
        placeholder: AppColors.placeholder,
        cardColor: AppColors.cardColor,
        resultColor: AppColors.resultColor,
        dividerLine: AppColors.dividerLine,
        barrierColor: const Color.fromARGB(255, 44, 45, 71).withValues(alpha: 0.8),
        iconColor: AppColors.icon,
        disableColor: AppColors.background,
      ),
    ],
  );
}