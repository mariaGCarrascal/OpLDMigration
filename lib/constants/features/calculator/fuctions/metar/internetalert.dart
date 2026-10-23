import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';

class Internetalert extends StatelessWidget {

  const Internetalert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.nowifiMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 21,
            ),
          ),
        ],
      ),
    );
  }
}