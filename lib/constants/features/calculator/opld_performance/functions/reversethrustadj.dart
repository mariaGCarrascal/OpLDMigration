import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Reversethrustadj{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? revsrinopRef;
  final Map<String, String>? baseDetails;

    Reversethrustadj({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
      this.conditionRef, this.autobrakeRef, this.revsrinopRef, this.baseDetails
    });
    
  double call() {
    Map<String, String> revsrInopData = {};
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
      //Search Reverse thrust adjustment Value for REVERSE THRUST ADJ 
      Iterable<XmlElement> target = [];
      final String revsrinop = revsrinopRef!.replaceAll('revsr Inop', '').trim(); 

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
            revsrInopData =  {
            for (final child in target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements('ReverserInoperativeAdjustment'))
                .where(
                  (lc) =>
                      lc.getAttribute('AmountOfRevInop')?.toUpperCase() ==
                      revsrinop.toUpperCase(),
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
            revsrInopData = {
            for (final child in target
                .where((f) => f.getAttribute('id') == selectedConfiguration)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements('ReverserInoperativeAdjustment'))
                .where(
                  (lc) =>
                      lc.getAttribute('AmountOfRevInop')?.toUpperCase() ==
                      revsrinop.toUpperCase(),
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
      print('Resultado de busqueda en Reversas: $revsrInopData');
      //Adjustement result value
      result = double.tryParse(revsrInopData[selectedautobrake] ?? '') ?? 0;

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
