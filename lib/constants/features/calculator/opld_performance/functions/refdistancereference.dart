import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Refdistancereference{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final Map<String, String>? baseDetails;

    Refdistancereference({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
      this.conditionRef, this.autobrakeRef, this.baseDetails
    });
    
  double call() {
    Map<String, String> distanceData = {};
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
      //Search Reference DIST Value for REF DIST 
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
            distanceData =  {
            for (final child in target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements('refDistance'))
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
            distanceData = {
            for (final child in target
                .where((f) => f.getAttribute('id') == selectedConfiguration)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements('refDistance'))
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
      print('Resultado de busqueda en ref distance: $distanceData');
      //Adjustement result value
      result = double.tryParse(distanceData[selectedautobrake] ?? '') ?? 0;

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
