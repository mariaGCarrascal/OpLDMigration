import 'package:flutter_application_5/service_dataxml/opldservice.dart';
import 'package:xml/xml.dart';

class Loadreversers{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;

  Loadreversers({ 
    this.aircraftRef, this.landingRef, 
    this.configurationRef, this.flapRef, this.conditionRef
  });
    
  List<String> call() {
    List<String> revsrInopData = [];
    List<String> reversers = [];
    String? nombre;
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedConfiguration = configurationRef;
    final String? selectedFlap = flapRef;
    final String? selectedCondition = conditionRef;

    try {
      //Search Reversers Values. 
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
            
        if (selectedFlap != null) {
          revsrInopData = target
            .where((f) => f.getAttribute('label') == selectedFlap)
            .expand((c) => c.findAllElements('reportedBrakingAction'))
            .where(
              (lc) =>
                  lc.getAttribute('label')?.toUpperCase() ==
                  selectedCondition!.toUpperCase(),
            )
            .expand((c) => c.findAllElements('ReverserInoperativeAdjustment'))
            .map(
              (node) => node.getAttribute('AmountOfRevInop'),
            )
            .whereType<String>()
            .toList();
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
          revsrInopData = target
            .where((f) => f.getAttribute('id') == selectedConfiguration)
            .expand((c) => c.findAllElements('reportedBrakingAction'))
            .where(
              (lc) =>
                  lc.getAttribute('label')?.toUpperCase() ==
                  selectedCondition!.toUpperCase(),
            )
            .expand((c) => c.findAllElements('ReverserInoperativeAdjustment'))
            .map(
              (node) => node.getAttribute('AmountOfRevInop'),
            )
            .whereType<String>()
            .toList();
        }
      }

      for (int i = 0; i < revsrInopData.length; i++) {
        nombre = '${revsrInopData[i]} revsr Inop';
        reversers.add(nombre); 
      }


      return reversers;

    } catch (e) {
      return reversers = []; 
    }
  }
  
} 
