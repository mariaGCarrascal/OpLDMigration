import 'package:flutter_application_5/service_dataxml/opldservice.dart';
import 'package:xml/xml.dart';

class Loadnonreversers{

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? conditionRef;

  Loadnonreversers({ 
    this.aircraftRef, this.landingRef, 
    this.configurationRef, this.conditionRef
  });
    
  List<String> call() {
    List<String> nonrevsrInopData = [];
    List<String> reversers = [];
    String? nombre;
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedConfiguration = configurationRef;
    final String? selectedCondition = conditionRef;

    try {
      //Search Reversers Values for Non-Normal Configuration. 
      Iterable<XmlElement> target = [];

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
        nonrevsrInopData = target
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

      for (int i = 0; i < nonrevsrInopData.length; i++) {
        nombre = '${nonrevsrInopData[i]} revsr Inop';
        reversers.add(nombre); 
      }


      return reversers;

    } catch (e) {
      return reversers = []; 
    }
  }
  
} 
