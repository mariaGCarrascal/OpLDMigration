import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/altitudedistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/approachspeeddistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/searchbaselinereference.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/weightdistancecalculation.dart';

class Oplddistancecalculator{

  final String? aircraftPicker;
  final String? landingPicker;
  final String? configurationPicker;
  final String? flapPicker;
  final String? rwyConditionPicker;
  final String? autobrakePicker;
  final String? revsrinopPicker;
  final String? speedbrakesPicker;
  final String? factorRef;
  final String? additiveRef;
  final String? weightRef;
  final String? altitudeRef;
  final String? isaRef;
  final String? slopeRef;
  final String? windRef;
  final String? vrefRef;  

    Oplddistancecalculator({ 
      this.aircraftPicker, this.landingPicker, this.configurationPicker,
      this.factorRef, this.additiveRef, this.flapPicker, this.rwyConditionPicker, 
      this.autobrakePicker, this.revsrinopPicker, this.speedbrakesPicker, 
      this.weightRef, this.altitudeRef, this.isaRef, this.slopeRef, this.windRef, this.vrefRef
    });

    String call() {
      String finalOpLDResult = '';
      Map<String, String> baseDetails = Searchbaselinereference(
        aircraftRef: aircraftPicker, landingRef: landingPicker, 
        configurationRef: configurationPicker, flapRef: flapPicker)();
      double? refDistanceResult;
      //double? weightAdjustmentDistanceResult; 
      //double? altitudeAdjustmentResult;
      double? windAdjustmentResult;
      double? slopeAdjustmentResult;
      double? tempAdjustmentResult;
      //double? approachSpeedAdjustmentResult;
      double? speedBrakesAdjustmentResult;
      double? reverserInoperativeAdjustmentResult;
      double? factor;
      double? additive;

    try {
      
      //Orden de calculo de OpLD:
      //Landing weight (REF DIST)

      //WT Adjustment (WT ADJ)
      double weightAdjustmentDistanceResult = Weightdistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, weightRef: weightRef, baseDetails: baseDetails)();
      //Altitud Adjustment (ALT ADJ)
      double altitudeAdjustmentResult = Altitudedistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, altitudeRef: altitudeRef, baseDetails: baseDetails)();
      //Wind adjustment (WIND ADJ)

      //Slope adjustment (SLOPE ADJ)

      //Temperature adjustment (TEMP ADJ)

      //Approach Speed adjustment (APP SPD ADJ)
      double approachSpeedAdjustmentResult = Approachspeeddistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, airspeedRef: vrefRef, baseDetails: baseDetails)();
      //Reverse thrust adjustment (REVERSE THRUST ADJ)

      //finalOpLDResult = ((refDistanceResult + ReverserInoperativeAdjustmentResult + weightAdjustmentDistanceResult + altitudeAdjustmentResult
      //+ WindAdjustmentResult + SlopeAdjustmentResult + TempAdjustmentResult + ApproachSpeedAdjustmentResult + SpeedBrakesAdjustmentResult)*factor) + additive;

      return finalOpLDResult; 

    } catch (e) {
      return "0"; 
    }
  }

}
