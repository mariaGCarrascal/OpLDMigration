import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Winddistancecalculation{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? windRef;
  final Map<String, String>? baseDetails;

    Winddistancecalculation({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
      this.conditionRef, this.autobrakeRef, this.windRef, this.baseDetails
    });
    
  double call() {
    Map<String, String> windData = {};
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
      //Search headWind/tailWind Wind adjustment Value for WIND ADJ 
      Iterable<XmlElement> target = [];
      double wind = double.tryParse(windRef ?? '') ?? 0;
      String nodeWindRef = wind >= 0
                        ? 'headWindAdjustment'
                        : 'tailWindAdjustment';
      String nodeIdRef = wind >= 0
                        ? 'HEADWIND ADJ'
                        : 'TAILWIND ADJ';

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
            windData =  {
            for (final child in target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements(nodeWindRef))
                .where(
                  (lc) =>
                      lc.getAttribute('id')?.toUpperCase() ==
                      nodeIdRef.toUpperCase(),
                )
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
            windData = {
            for (final child in target
                .where((f) => f.getAttribute('id') == selectedConfiguration)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements(nodeWindRef))
                .where(
                  (lc) =>
                      lc.getAttribute('id')?.toUpperCase() ==
                      nodeIdRef.toUpperCase(),
                )
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
      print('Resultado de busqueda en vientos en caso $nodeWindRef: $windData');
      //Operation for adjustement result
      double selectedWind = double.tryParse(windRef ?? '') ?? 0;
      double windAdjustment = double.tryParse(windData[windData.keys.first] ?? '') ?? 0;     
      double baseLineRefWind = double.tryParse(baseDetails!['refWind'] ?? '') ?? 0;
      double perHowManyWindSpeedUnits = double.tryParse(baseDetails!['perHowManyWindSpeedUnits'] ?? '') ?? 0;

      if (selectedWind < baseLineRefWind) {
        double windDifference = baseLineRefWind - selectedWind;
        result = ((windAdjustment / perHowManyWindSpeedUnits) * windDifference);

      } else {
        double windDifference = selectedWind - baseLineRefWind;
        result = ((windAdjustment / perHowManyWindSpeedUnits) * windDifference);

      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
