import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Speedbrakesdistance{

  final String? aircraftRef;
  final String? landingRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? speedbrakeRef;
  final Map<String, String>? baseDetails;

    Speedbrakesdistance({ 
      this.aircraftRef, this.landingRef, this.flapRef, 
      this.conditionRef, this.autobrakeRef, this.speedbrakeRef, this.baseDetails
    });
    
  double call() {
    Map<String, String> brakesData = {};
    double result;
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedflap = flapRef;
    final String? selectedCondition = conditionRef;
    final String? selectedautobrake = autobrakeRef;

    try {
      //Search MANUAL/AUTOMATIC SpeedBrakesAdjustment Value 
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
            brakesData =  {
            for (final child in target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements('SpeedBrakesAdjustment'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      speedbrakeRef!.toUpperCase(),
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
      print('Resultado de busqueda en speedbrakes en condicion $selectedCondition: $brakesData');
      //Adjustement result
      if (selectedLanding == 'Non-Normal') {
        result = 0;
      } else {
        result = double.tryParse(brakesData['$selectedautobrake'] ?? '0') ?? 0;     
      }


      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
