import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadautobrakes{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;

    Loadautobrakes({ 
      this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, this.conditionRef,
    });
    
  List<String> call() {
    List<String> autobrakesSettings = [];
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;
    final String? selectedflap = flapRef;
    final String? selectedCondition = conditionRef;

    if (aircraftRef == null || landingRef == null || configurationRef == null || flapRef == null || conditionRef == null) {
      return autobrakesSettings = [];
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
            autobrakesSettings = target
                  .where((f) => f.getAttribute('label') == selectedflap)
                  .expand((c) => c.findAllElements('reportedBrakingAction'))
                  .where(
                    (lc) =>
                        lc.getAttribute('label')?.toUpperCase() ==
                        selectedCondition!.toUpperCase(),
                  )
                  .expand((c) => c.findAllElements('refDistance')) 
                  .expand((ref) => ref.findElements('*'))          
                  .map((child) => child.getAttribute('id'))        
                  .where((id) => id != null)                       
                  .cast<String>()                                  
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
            autobrakesSettings = target
                .where((f) => f.getAttribute('id') == selectedConfigurationType)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                  )
                .expand((c) => c.findAllElements('refDistance')) 
                .expand((ref) => ref.findElements('*'))          
                .map((child) => child.getAttribute('id'))        
                .where((id) => id != null)                       
                .cast<String>()                                  
                .toList();
          }
        }
      
      return autobrakesSettings;

    } catch (e) {
      return autobrakesSettings = []; 
    }
  }
  
} 
