import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadweight{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;

    Loadweight({ 
      this.aircraftRef, this.landingRef, this.configurationRef
    });
    
  List<String> call() {
    List<String> comentariosNon = [];
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;

    if (aircraftRef == null || landingRef == null || configurationRef == null) {
      return comentariosNon = [];
    }

    try {

      Iterable<XmlElement> target = [];

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
        comentariosNon = target
            .where((f) => f.getAttribute('id') == selectedConfigurationType)
            .expand((c) => c.findAllElements('Comments'))
            .map((e) => e.innerText)
            .toList();
      }

      return comentariosNon;

    } catch (e) {
      return comentariosNon = []; 
    }
  }
  
} 
