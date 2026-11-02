import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color placeholder;
  final Color cardColor;
  final Color disableColor;
  final Color resultColor;
  final Color dividerLine;
  final Color? opacityButton;
  final Color barrierColor;
  final Color? iconColor;


  const AppThemeExtension({
    required this.placeholder,
    required this.cardColor,
    required this.disableColor,
    required this.resultColor,
    required this.dividerLine,
    this.opacityButton,
    required this.barrierColor,
    required this.iconColor,
  });

  @override
  AppThemeExtension copyWith({
    Color? placeholder,
    Color? cardColor,
    Color? disableColor,
    Color? resultColor,
    Color? dividerLine,
    Color? opacityButton,
    Color? barrierColor,
    Color? iconColor,
  }) {
    return AppThemeExtension(
      placeholder: placeholder ?? this.placeholder,
      cardColor: cardColor ?? this.cardColor,
      disableColor: disableColor ?? this.disableColor,
      resultColor: resultColor ?? this.resultColor,
      dividerLine: dividerLine ?? this.dividerLine,
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
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      disableColor: Color.lerp(disableColor, other.disableColor, t)!,
      resultColor: Color.lerp(resultColor, other.resultColor, t)!,
      dividerLine: Color.lerp(dividerLine, other.dividerLine, t)!,
      opacityButton: Color.lerp(opacityButton, other.opacityButton, t),
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }
}