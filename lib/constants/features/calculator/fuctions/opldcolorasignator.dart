
import 'package:flutter/services.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';

class Opldcolorasignator{

  final String? opldReference;
  final String? netldaReference;
  

    Opldcolorasignator({ 
      this.opldReference, this.netldaReference,
    });

    Color call() {

      Color colorDistanceResult;

      if (opldReference == null || netldaReference == null) {
        colorDistanceResult = AppColors.placeholderDark;
        return colorDistanceResult;
      }

      final int landingDistanceResult = int.parse(netldaReference!.trim());
      final int opldCalculatedDistance = int.parse(opldReference!.trim());

      if ((landingDistanceResult - opldCalculatedDistance) < 0) {
        colorDistanceResult = AppColors.errorColor;
      
      } else if ((opldCalculatedDistance <= landingDistanceResult) && (opldCalculatedDistance >= (landingDistanceResult - (landingDistanceResult * 0.05)))) {
        colorDistanceResult =  AppColors.activeColor;
      
      } else {
        colorDistanceResult = AppColors.placeholderDark;
      }
    
      return colorDistanceResult; 

    }
}


