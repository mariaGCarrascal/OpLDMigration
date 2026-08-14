import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color placeholder;
  final Color cardDark;
  final Color disableColor;
  final Color resultColor;
  final Color okPriButBgDark;
  final Color okPriButBrDark;
  final Color cancelPriButBgDark;
  final Color cancelPriButBrDark;
  final Color? opacityButton;
  final Color barrierColor;
  final Color? iconColor;


  const AppThemeExtension({
    required this.placeholder,
    required this.cardDark,
    required this.disableColor,
    required this.resultColor,
    required this.okPriButBgDark,
    required this.okPriButBrDark,
    required this.cancelPriButBgDark,
    required this.cancelPriButBrDark,
    this.opacityButton,
    required this.barrierColor,
    required this.iconColor,
  });

  @override
  AppThemeExtension copyWith({
    Color? placeholder,
    Color? cardDark,
    Color? disableColor,
    Color? resultColor,
    Color? okPriButBgDark,
    Color? okPriButBrDark,
    Color? cancelPriButBgDark,
    Color? cancelPriButBrDark,
    Color? opacityButton,
    Color? barrierColor,
    Color? iconColor,
  }) {
    return AppThemeExtension(
      placeholder: placeholder ?? this.placeholder,
      cardDark: cardDark ?? this.cardDark,
      disableColor: disableColor ?? this.disableColor,
      resultColor: resultColor ?? this.resultColor,
      okPriButBgDark: okPriButBgDark ?? this.okPriButBgDark,
      okPriButBrDark: okPriButBrDark ?? this.okPriButBrDark,
      cancelPriButBgDark: cancelPriButBgDark ?? this.cancelPriButBgDark,
      cancelPriButBrDark: cancelPriButBrDark ?? this.cancelPriButBrDark,
      opacityButton: opacityButton ?? this.opacityButton,
      barrierColor: barrierColor ?? this.barrierColor,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      cardDark: Color.lerp(cardDark, other.cardDark, t)!,
      disableColor: Color.lerp(disableColor, other.disableColor, t)!,
      resultColor: Color.lerp(resultColor, other.resultColor, t)!,
      okPriButBgDark: Color.lerp(okPriButBgDark, other.okPriButBgDark, t)!,
      okPriButBrDark: Color.lerp(okPriButBrDark, other.okPriButBrDark, t)!,
      cancelPriButBgDark: Color.lerp(cancelPriButBgDark, other.cancelPriButBgDark, t)!,
      cancelPriButBrDark: Color.lerp(cancelPriButBrDark, other.cancelPriButBrDark, t)!,
      opacityButton: Color.lerp(opacityButton, other.opacityButton, t),
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }
}