import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadcomments{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;

    Loadcomments({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef,
    });
    
  List<String> call() {
    List<String> comentarios = [];
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;
    final String? selectedflap = flapRef;

    if (aircraftRef == null || landingRef == null || configurationRef == null || flapRef == null) {
      return comentarios = [];
    }

    try {

      Iterable<XmlElement> target = [];

      if(selectedLandingType == 'Normal') {

          if (selectedAircraftType != null && selectedLandingType != null) {
            target = xmlDocument
                .findAllElements('aircraft')
                .where(
                  (a) =>
                      a.getAttribute('id') == selectedAircraftType ||
                      a.getAttribute('label') == selectedAircraftType,
                )
                .expand((l) => l.findAllElements('landingCondition'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedLandingType.toUpperCase(),
                )
                .expand((f) => f.findAllElements('Flap'));
          }
          
          if (selectedflap != null) {
            comentarios = target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('Comments'))
                .map((e) => e.innerText)
                .toList();
          }

      } else {

        if (selectedAircraftType != null && selectedLandingType != null) {
            target = xmlDocument
                .findAllElements('aircraft')
                .where(
                  (a) =>
                      a.getAttribute('id') == selectedAircraftType ||
                      a.getAttribute('label') == selectedAircraftType,
                )
                .expand((l) => l.findAllElements('landingCondition'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedLandingType.toUpperCase(),
                )
                .expand((f) => f.findAllElements('nonNormalConfiguration'));
          }
          
          if (selectedConfigurationType != null) {
            comentarios = target
                .where((f) => f.getAttribute('id') == selectedConfigurationType)
                .expand((c) => c.findAllElements('Comments'))
                .map((e) => e.innerText)
                .toList();
          }
        }

      return comentarios;

    } catch (e) {
      return comentarios = []; 
    }
  }
  
} 
