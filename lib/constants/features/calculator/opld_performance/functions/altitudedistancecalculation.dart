import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Altitudedistancecalculation{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? altitudeRef;
  final Map<String, String>? baseDetails;

    Altitudedistancecalculation({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
      this.conditionRef, this.autobrakeRef, this.altitudeRef, this.baseDetails
    });
    
  double call() {
    Map<String, String> altitudeData = {};
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
      //Search Above and Below Values for ALT ADJ
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
            altitudeData = {
              for (final child in target
                  .where((f) => f.getAttribute('label') == selectedflap)
                  .expand((c) => c.findAllElements('reportedBrakingAction'))
                  .where(
                    (lc) =>
                        lc.getAttribute('label')?.toUpperCase() ==
                        selectedCondition!.toUpperCase(),
                  )
                  .expand((c) => c.findAllElements('altitudeAdjustment'))
                  .where(
                    (lc) =>
                        lc.getAttribute('id')?.toUpperCase() ==
                        selectedautobrake!.toUpperCase(),
                  )
                  .expand((ref) => ref.findElements('*')))
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
            altitudeData = {
              for (final child in target
                  .where((f) => f.getAttribute('id') == selectedConfiguration)
                  .expand((c) => c.findAllElements('reportedBrakingAction'))
                  .where(
                    (lc) =>
                        lc.getAttribute('label')?.toUpperCase() ==
                        selectedCondition!.toUpperCase(),
                  )
                  .expand((c) => c.findAllElements('altitudeAdjustment'))
                  .where(
                    (lc) =>
                        lc.getAttribute('id')?.toUpperCase() ==
                        selectedautobrake!.toUpperCase(),
                  )
                  .expand((ref) => ref.findElements('*')))
                child.name.local: child.innerText.trim(),
            };

          }
        }
      
      //Operation for adjustement result
      double selectedAltitude = double.tryParse(altitudeRef ?? '') ?? 0.0;
      double aboveSwitchAlt = double.tryParse(altitudeData['aboveSwitchAlt'] ?? '') ?? 0.0;
      double belowSwitchAlt = double.tryParse(altitudeData['belowSwitchAlt'] ?? '') ?? 0.0;
      double baseLineRefAlt = double.tryParse(baseDetails!['refAlt'] ?? '') ?? 0.0;
      double perHowManyAltUnits = double.tryParse(baseDetails!['perHowManyAltUnits'] ?? '') ?? 0.0;
      double switchAlt = double.tryParse(baseDetails!['switchAlt'] ?? '') ?? 0.0;

      if (selectedAltitude <= switchAlt) {
        double altitudeDifference = selectedAltitude - baseLineRefAlt;
        result = ((belowSwitchAlt / perHowManyAltUnits) * altitudeDifference);

      } else if (selectedAltitude > switchAlt) {
        double altitudeDifference = selectedAltitude - switchAlt;
        result = ((belowSwitchAlt / perHowManyAltUnits) * switchAlt) + ((aboveSwitchAlt / perHowManyAltUnits) * altitudeDifference);

      } else {
        result = double.nan;
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
