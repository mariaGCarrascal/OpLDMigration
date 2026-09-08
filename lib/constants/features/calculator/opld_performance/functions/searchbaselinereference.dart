import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Searchbaselinereference{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;

    Searchbaselinereference({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef
    });
    
  Map<String, String> call() {
    Map<String, String> baseReference = {};
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedConfiguration = configurationRef;
    final String? selectedflap = flapRef;

    if (aircraftRef == null || landingRef == null) {
      return baseReference = {};
    }

    try {

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
            baseReference = {
              for (final subchild in target
                  .where((f) => f.getAttribute('label') == selectedflap)
                  .expand((c) => c.findAllElements('baselineReferenceDetails'))
                  .expand((ref) => ref.findElements('*'))
                  .expand((child) => child.findElements('*')))
                subchild.name.local: subchild.innerText.trim(),
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
            baseReference = {
              for (final subchild in target
                  .where((f) => f.getAttribute('id') == selectedConfiguration)
                  .expand((c) => c.findAllElements('baselineReferenceDetails'))
                  .expand((ref) => ref.findElements('*'))
                  .expand((child) => child.findElements('*')))
                subchild.name.local: subchild.innerText.trim(),
            };

          }
        }
      
      return baseReference;

    } catch (e) {
      return baseReference = {}; 
    }
  }
  
} 
