import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Approachspeeddistancecalculation{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? airspeedRef;
  final Map<String, String>? baseDetails;

    Approachspeeddistancecalculation({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
      this.conditionRef, this.autobrakeRef, this.airspeedRef, this.baseDetails
    });
    
  double call() {
    Map<String, String> airspeedData = {};
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
      //Search Approach Speed Adjustment Value for APP SPD ADJ
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
            airspeedData =  {
            for (final child in target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements('approachSpeedAdjustment'))
                .expand((c) => c.children.whereType<XmlElement>())
                .where(
                  (child) =>
                      child.getAttribute('id')?.toUpperCase() ==
                      selectedautobrake!.toUpperCase(),
                ))
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
            airspeedData = {
            for (final child in target
                .where((f) => f.getAttribute('id') == selectedConfiguration)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements('approachSpeedAdjustment'))
                .expand((c) => c.children.whereType<XmlElement>())
                .where(
                  (child) =>
                      child.getAttribute('id')?.toUpperCase() ==
                      selectedautobrake!.toUpperCase(),
                ))
              child.name.local: child.innerText.trim(),
          };

          }
        }
      print('Resultado de busqueda en airspeed aprroach (VREF): $airspeedData');
      //Operation for adjustement result
      double selectedVref = double.tryParse(airspeedRef ?? '') ?? 0;
      double approachSpeedAdjustment = double.tryParse(airspeedData[airspeedData.keys.first] ?? '') ?? 0;
      double baseLineRefVref = double.tryParse(baseDetails!['refDltaVref'] ?? '') ?? 0;
      double perHowManyAirspeedUnitsAboveVref = double.tryParse(baseDetails!['perHowManyAirspeedUnitsAboveVref'] ?? '') ?? 0;

      if (selectedVref >= baseLineRefVref) {
        result = ((approachSpeedAdjustment / perHowManyAirspeedUnitsAboveVref) * (selectedVref - baseLineRefVref));

      } else if (selectedAircraft == "E190 CF34-10E5" && selectedVref >= 0) {
        result = ((approachSpeedAdjustment / perHowManyAirspeedUnitsAboveVref) * (selectedVref - baseLineRefVref));
                
      } else {
        result = double.nan;
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
