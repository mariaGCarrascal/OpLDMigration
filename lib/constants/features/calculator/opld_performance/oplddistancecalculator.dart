import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/altitudedistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/approachspeeddistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/refdistancereference.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/reversethrustadj.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/slopedistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/speedbrakesdistance.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/tempdistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/weightdistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/winddistancecalculation.dart';

class Oplddistancecalculator{

  final Map<String, String>? aircraftBaseDetails;
  final String? aircraftPicker;
  final String? landingPicker;
  final String? configurationPicker;
  final String? flapPicker;
  final String? rwyPicker;
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

    Oplddistancecalculator({ this.aircraftBaseDetails,
      this.aircraftPicker, this.landingPicker, this.configurationPicker,
      this.factorRef, this.additiveRef, this.rwyPicker, this.flapPicker, this.rwyConditionPicker, 
      this.autobrakePicker, this.revsrinopPicker, this.speedbrakesPicker, 
      this.weightRef, this.altitudeRef, this.isaRef, this.slopeRef, this.windRef, this.vrefRef
    });

    String call() {
      double finalOpLDResult = 0;

    try {
      
      //OpLD Calculation Result values Order:
      
      //Landing weight (REF DIST)
      double refDistanceResult = Refdistancereference(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, baseDetails: aircraftBaseDetails)();

      //WT Adjustment (WT ADJ) Funciona
      double weightAdjustmentDistanceResult = Weightdistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, weightRef: weightRef, baseDetails: aircraftBaseDetails)();

      //Altitud Adjustment (ALT ADJ) funciona
      double altitudeAdjustmentResult = Altitudedistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, altitudeRef: altitudeRef, baseDetails: aircraftBaseDetails)();

      //Wind adjustment (WIND ADJ)
      double windAdjustmentResult = Winddistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, windRef: windRef, baseDetails: aircraftBaseDetails)();

      //Slope adjustment (SLOPE ADJ)
      double slopeAdjustmentResult = Slopedistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, slopeRef: slopeRef, baseDetails: aircraftBaseDetails)();

      //Temperature adjustment (TEMP ADJ)
      double tempAdjustmentResult = Tempdistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, isaRef: isaRef, baseDetails: aircraftBaseDetails)();

      //Approach Speed adjustment (APP SPD ADJ)
      double approachSpeedAdjustmentResult = Approachspeeddistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, airspeedRef: vrefRef, baseDetails: aircraftBaseDetails)();
      
      //SpeedBrakes adjustment (REF LAND DIST)
      double speedBrakesAdjustmentResult = Speedbrakesdistance(
        aircraftRef: aircraftPicker, landingRef: landingPicker, flapRef: flapPicker, 
        autobrakeRef: autobrakePicker, speedbrakeRef: speedbrakesPicker, baseDetails: aircraftBaseDetails)();

      //Reverse thrust adjustment (REVERSE THRUST ADJ)
      double reverserInoperativeAdjustmentResult = Reversethrustadj(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, revsrinopRef: revsrinopPicker, baseDetails: aircraftBaseDetails)();
      
      //Runway Airport reference values
      double factor = double.tryParse(factorRef ?? '1') ?? 1;
      double additive = double.tryParse(additiveRef ?? '0') ?? 0;

      //OpLD Result Value
      finalOpLDResult = (((refDistanceResult + reverserInoperativeAdjustmentResult + weightAdjustmentDistanceResult + altitudeAdjustmentResult
      + windAdjustmentResult + slopeAdjustmentResult + tempAdjustmentResult + approachSpeedAdjustmentResult + speedBrakesAdjustmentResult)*factor) + additive);

      return finalOpLDResult.round().toString().trim(); 

    } catch (e) {
      return "0"; 
    }
  }

}
