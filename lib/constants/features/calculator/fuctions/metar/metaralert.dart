import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';

class Metaralert extends StatelessWidget {

  final String? message;

  const Metaralert({
    super.key, this.message
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
            '$message',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}