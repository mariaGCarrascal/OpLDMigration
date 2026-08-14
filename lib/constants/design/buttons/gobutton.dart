import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';
import 'package:flutter_application_5/constants/design/text/app_text.dart';
//import 'package:flutter_application_5/theme/app_theme_extesion.dart';

class GoButton extends StatelessWidget {
  final String? label;
  final VoidCallback onPressed;

  final Color? color;
  final Color? textColor;
  final double? opacity;
  final double? borderWidth;

  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontsize;

  final TextStyle? textStyle;

  const GoButton({
    super.key,
    this.label,
    required this.onPressed,
    this.textStyle,
    this.color,
    this.textColor,
    this.opacity,
    this.borderWidth,
    this.width,
    this.height,
    this.borderRadius,
    this.fontsize,
  });

  @override
  Widget build(BuildContext context) {

    //final Size screenSize = MediaQuery.of(context).size;
    
    //final appTheme = Theme.of(context).extension<AppThemeExtension>()!;

    return Center(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                 // backgroundColor: appTheme.backgroundDark,
                  //foregroundColor: AppColors.iconDark,
                  fixedSize: const Size(100, 100),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                    side: BorderSide(
                      color: AppColors.iconDark,
                      width: 3,
                    ),
                  ), 
                  elevation: 4,
                ),
                child: OpLDAppText.bold(
                  AppStrings.goButton,
                  color: AppColors.textColor2Dark,
                ),
              ),
            );
  }
}
