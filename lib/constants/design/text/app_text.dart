import 'package:flutter/material.dart';

class OpLDAppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const OpLDAppText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
  });

  // Regular
  factory OpLDAppText.regular(
    String text, {
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? height,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return OpLDAppText(
      text,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
      textAlign: textAlign,
      height: height,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Medium
  factory OpLDAppText.medium(
    String text, {
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? height,
  }) {
    return OpLDAppText(
      text,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color,
      textAlign: textAlign,
      height: height,
    );
  }

  // SemiBold
  factory OpLDAppText.semiBold(
    String text, {
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? height,
  }) {
    return OpLDAppText(
      text,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
      textAlign: textAlign,
      height: height,
    );
  }

  // bold
  factory OpLDAppText.bold(
    String text, {
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? height,
  }) {
    return OpLDAppText(
      text,
      fontSize: fontSize ?? 30,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color,
      textAlign: textAlign,
      height: height,
    );
  }

  // extraBold
  factory OpLDAppText.extraBold(
    String text, {
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    double? height,
    Key? key,
  }) {
    return OpLDAppText(
      text,
      fontSize: fontSize ?? 16.0,
      fontWeight: fontWeight ?? FontWeight.w800,
      color: color,
      textAlign: textAlign,
      height: height,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      textScaleFactor: 1.5,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        height: height,
      ),
    );
  }
}
