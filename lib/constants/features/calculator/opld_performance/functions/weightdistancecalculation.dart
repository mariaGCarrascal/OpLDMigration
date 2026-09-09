import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Weightdistancecalculation{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? weightRef;
  final Map<String, String>? baseDetails;

    Weightdistancecalculation({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
      this.conditionRef, this.autobrakeRef, this.weightRef, this.baseDetails
    });
    
  double call() {
    Map<String, String> weightData = {};
    double result;
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedConfiguration = configurationRef;
    final String? selectedflap = flapRef;
    final String? selectedCondition = conditionRef;
    final String? selectedautobrake = autobrakeRef;

    try {
      //Search Above and Below Values for WT ADJ
      Iterable<XmlElement> target = [];

      if(selectedLanding == 'Normal') {

          if (selectedAircraft != null && selectedLanding != null) {
            target = xmlDocument
                .findAllElements('aircraft')
                .where(
                  (a) =>
                      a.getAttribute('id') == selectedAircraft ||
                      a.getAttribute('label') == selectedAircraft,
                )
                .expand((l) => l.findAllElements('landingCondition'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedLanding.toUpperCase(),
                )
                .expand((f) => f.findAllElements('Flap'));
          }
          
          if (selectedflap != null) {
            weightData = {
              for (final child in target
                  .where((f) => f.getAttribute('label') == selectedflap)
                  .expand((c) => c.findAllElements('reportedBrakingAction'))
                  .where(
                    (lc) =>
                        lc.getAttribute('label')?.toUpperCase() ==
                        selectedCondition!.toUpperCase(),
                  )
                  .expand((c) => c.findAllElements('weightAdjustment'))
                  .expand(
                    (altitudeAdjustment) => altitudeAdjustment
                        .findElements('*')
                        .where(
                          (child) =>
                              child.getAttribute('id')?.toUpperCase() ==
                              selectedautobrake!.toUpperCase(),
                        ),
                  )
                  .expand((autobrake) => autobrake.findElements('*')))
                child.name.local: child.innerText.trim(),
            };

          }


      } else {

        if (selectedAircraft != null && selectedLanding != null) {
            target = xmlDocument
                .findAllElements('aircraft')
                .where(
                  (a) =>
                      a.getAttribute('id') == selectedAircraft ||
                      a.getAttribute('label') == selectedAircraft,
                )
                .expand((l) => l.findAllElements('landingCondition'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedLanding.toUpperCase(),
                )
                .expand((f) => f.findAllElements('nonNormalConfiguration'));
          }
          
          if (selectedConfiguration != null) {
            weightData = {
              for (final child in target
                  .where((f) => f.getAttribute('id') == selectedConfiguration)
                  .expand((c) => c.findAllElements('reportedBrakingAction'))
                  .where(
                    (lc) =>
                        lc.getAttribute('label')?.toUpperCase() ==
                        selectedCondition!.toUpperCase(),
                  )
                  .expand((c) => c.findAllElements('weightAdjustment'))
                  .expand(
                    (altitudeAdjustment) => altitudeAdjustment
                        .findElements('*')
                        .where(
                          (child) =>
                              child.getAttribute('id')?.toUpperCase() ==
                              selectedautobrake!.toUpperCase(),
                        ),
                  )
                  .expand((autobrake) => autobrake.findElements('*')))
                child.name.local: child.innerText.trim(),
            };

          }
        }
      print('Resultado de busqueda en weight: $weightData');
      //Operation for adjustement result
      double selectedWeight = double.tryParse(weightRef ?? '') ?? 0;
      double aboveRefWgtValue = double.tryParse(weightData['aboveRefWgt'] ?? '') ?? 0;
      double belowRefWgtValue = double.tryParse(weightData['belowRefWgt'] ?? '') ?? 0;
      double baseLineRefWeight = double.tryParse(baseDetails!['refWgt'] ?? '') ?? 0;
      double perHowManyWgtUnits = double.tryParse(baseDetails!['perHowManyWgtUnits'] ?? '') ?? 0;


      if (selectedWeight < baseLineRefWeight) {
        double weightDifference = baseLineRefWeight - selectedWeight;

        result = ((belowRefWgtValue / perHowManyWgtUnits) * weightDifference);

      } else if (selectedWeight > baseLineRefWeight) {

        double weightDifference = selectedWeight - baseLineRefWeight;

        result = ((aboveRefWgtValue / perHowManyWgtUnits) * weightDifference);

      } else {
        result = 0;
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
