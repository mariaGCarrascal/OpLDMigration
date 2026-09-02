import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Searchdefault{

  final String? aircraftRef;

    Searchdefault({ 
      this.aircraftRef
    });
    
  List<String> call() {
    List<String> defaultValues = [];
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraftType = aircraftRef;

    if (aircraftRef == null) {
      return defaultValues = [];
    }

    try {

      Iterable<XmlElement> target = [];

      if (selectedAircraftType != null) {
        target = xmlDocument
            .findAllElements('aircraft')
            .where(
              (a) =>
                  a.getAttribute('id') == selectedAircraftType ||
                  a.getAttribute('label') == selectedAircraftType,
            )
            .expand((f) => [f.findAllElements('landingCondition').first]);
      }
     
      if (selectedAircraftType != null) {
        defaultValues = target
          .expand((c) => [
          ...c.findAllElements('VrefAdditiveDefaultValue'),
          ...c.findAllElements('flapDefaultLabel'),
          ...c.findAllElements('autobrakeSetting_id_ofDefault'),
          ...c.findAllElements('reportedBrakingAction_label_ofDefault'),
          ...c.findAllElements('weightDefaultValue'),
          ...c.findAllElements('weightMAXvalue'),
          ...c.findAllElements('weightMINvalue'),
          ...c.findAllElements('VrefAdditiveMINvalue'),
          ...c.findAllElements('VrefAdditiveMAXvalue'),
          ...c.findAllElements('altitudeMINvalue'),
          ...c.findAllElements('altitudeMAXvalue'),
          ...c.findAllElements('slopeMINvalue'),
          ...c.findAllElements('slopeMAXvalue'),
          ...c.findAllElements('deltaISA_MINvalue'),
          ...c.findAllElements('deltaISA_MAXvalue'),
          ...c.findAllElements('reversersInoperativeDefaultValue'),
          ...c.findAllElements('reversersInoperativeMINvalue'),
          ...c.findAllElements('reversersInoperativeMAXvalue'),
          ...c.findAllElements('altitudeDefaultValue'),
          ...c.findAllElements('reportedBrakingAction_label_ofDefault'),
          ...c.findAllElements('windDefaultValue'),
          ...c.findAllElements('windMINvalue'),
          ...c.findAllElements('windMAXvalue'),
          ])
            .map((e) => e.innerText)
            .toList();
      }

      return defaultValues;

    } catch (e) {
      return defaultValues = []; 
    }
  }
  
} 
