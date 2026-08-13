import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/theme/app_theme_extesion.dart';

class DarkTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.backgroundDark,
      secondary: AppColors.activeColor,
      surface: AppColors.surfaceDark,

      onPrimary: AppColors.textColor1Dark,
      onSecondary: AppColors.textColor2Dark,
      onSurface: AppColors.textColor3Dark,
      error: AppColors.errorColor,
      onError: AppColors.errorColor,
    ),
    extensions: [
      AppThemeExtension(
        placeholder: AppColors.placeholder,
        bottomSheetDark: AppColors.bottomSheetDark,
        resultColor: AppColors.resultColor,
        okPriButBgDark: AppColors.okPriButBgDark,
        okPriButBrDark: AppColors.okPriButBrDark,
        cancelPriButBgDark: AppColors.cancelPriButBgDark,
        cancelPriButBrDark: AppColors.cancelPriButBrDark,
        barrierColor: const Color.fromARGB(255, 44, 45, 71).withOpacity(0.8),
        iconColor: AppColors.iconDark,
        disableColor: AppColors.backgroundDark,
      ),
    ],
  );
}