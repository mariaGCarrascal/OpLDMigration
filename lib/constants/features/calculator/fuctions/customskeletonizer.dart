import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Customskeletonizer extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const Customskeletonizer({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      ignorePointers: isLoading,
      effect: ShimmerEffect(
        baseColor: AppColors.backgroundDark,
        highlightColor: AppColors.grey,
      ),
      child: child,
    );
  }
}