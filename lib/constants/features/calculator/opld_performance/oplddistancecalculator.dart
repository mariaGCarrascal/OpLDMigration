import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/altitudedistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/approachspeeddistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/refdistancereference.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/reversethrustadj.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/searchbaselinereference.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/slopedistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/speedbrakesdistance.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/tempdistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/weightdistancecalculation.dart';
import 'package:flutter_application_5/constants/features/calculator/opld_performance/functions/winddistancecalculation.dart';

class Oplddistancecalculator{

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

    Oplddistancecalculator({ 
      this.aircraftPicker, this.landingPicker, this.configurationPicker,
      this.factorRef, this.additiveRef, this.rwyPicker, this.flapPicker, this.rwyConditionPicker, 
      this.autobrakePicker, this.revsrinopPicker, this.speedbrakesPicker, 
      this.weightRef, this.altitudeRef, this.isaRef, this.slopeRef, this.windRef, this.vrefRef
    });

    String call() {
      double finalOpLDResult = 0;
      Map<String, String> baseDetails = Searchbaselinereference(
        aircraftRef: aircraftPicker, landingRef: landingPicker, 
        configurationRef: configurationPicker, flapRef: flapPicker)();

    try {
      
      //OpLD Calculation Result values Order:
      print('Resultados de busquedas generales del OpLD en $landingPicker en modelo $aircraftPicker:');
      //Landing weight (REF DIST)
      double refDistanceResult = Refdistancereference(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, baseDetails: baseDetails)();

      //WT Adjustment (WT ADJ)
      double weightAdjustmentDistanceResult = Weightdistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, weightRef: weightRef, baseDetails: baseDetails)();

      //Altitud Adjustment (ALT ADJ)
      double altitudeAdjustmentResult = Altitudedistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, altitudeRef: altitudeRef, baseDetails: baseDetails)();

      //Wind adjustment (WIND ADJ)
      double windAdjustmentResult = Winddistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, windRef: windRef, baseDetails: baseDetails)();

      //Slope adjustment (SLOPE ADJ)
      double slopeAdjustmentResult = Slopedistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, slopeRef: slopeRef, baseDetails: baseDetails)();

      //Temperature adjustment (TEMP ADJ)
      double tempAdjustmentResult = Tempdistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, isaRef: isaRef, baseDetails: baseDetails)();

      //Approach Speed adjustment (APP SPD ADJ)
      double approachSpeedAdjustmentResult = Approachspeeddistancecalculation(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, airspeedRef: vrefRef, baseDetails: baseDetails)();
      
      //SpeedBrakes adjustment (REF LAND DIST)
      double speedBrakesAdjustmentResult = Speedbrakesdistance(
        aircraftRef: aircraftPicker, landingRef: landingPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, speedbrakeRef: speedbrakesPicker, baseDetails: baseDetails)();

      //Reverse thrust adjustment (REVERSE THRUST ADJ)
      double reverserInoperativeAdjustmentResult = Reversethrustadj(
        aircraftRef: aircraftPicker, landingRef: landingPicker, configurationRef: configurationPicker, flapRef: flapPicker, 
        conditionRef: rwyConditionPicker, autobrakeRef: autobrakePicker, revsrinopRef: revsrinopPicker, baseDetails: baseDetails)();
      
      //Runway Airport reference values
      double factor = double.tryParse(factorRef ?? '1') ?? 1;
      double additive = double.tryParse(additiveRef ?? '0') ?? 0;


      //OpLD Result Value
      finalOpLDResult = (((refDistanceResult + reverserInoperativeAdjustmentResult + weightAdjustmentDistanceResult + altitudeAdjustmentResult
      + windAdjustmentResult + slopeAdjustmentResult + tempAdjustmentResult + approachSpeedAdjustmentResult + speedBrakesAdjustmentResult)*factor) + additive);
      print('[Resultados]:');
      print('Resultados de Landing weight (REF DIST): $refDistanceResult');
      print('Resultados de WT Adjustment (WT ADJ): $weightAdjustmentDistanceResult');
      print('Resultados de Altitud Adjustment (ALT ADJ): $altitudeAdjustmentResult');
      print('Resultados de Wind adjustment (WIND ADJ): $windAdjustmentResult');
      print('Resultados de Slope adjustment (SLOPE ADJ): $slopeAdjustmentResult');
      print('Resultados de Temperature adjustment (TEMP ADJ): $tempAdjustmentResult');
      print('Resultados de Approach Speed adjustment (APP SPD ADJ): $approachSpeedAdjustmentResult');
      print('Resultados de SpeedBrakes adjustment (REF LAND DIST): $speedBrakesAdjustmentResult');
      print('Resultados de Reverse thrust adjustment (REVERSE THRUST ADJ): $reverserInoperativeAdjustmentResult');
      print('Resultados de Factor ruway: $factor');
      print('Resultados de Additive ruway: $additive');

      return finalOpLDResult.round().toString().trim(); 

    } catch (e) {
      return "0"; 
    }
  }

}
