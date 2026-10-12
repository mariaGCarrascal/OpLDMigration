import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadcrosswinds{

  final String? aircraftRef;

    Loadcrosswinds({ 
      this.aircraftRef
    });
    
  Map<String, String> call() {
    Map<String, String> crosswindValues = {};
    final XmlDocument xmlDocument = OpLdService.instance.document;
    final String? selectedAircraftType = aircraftRef;

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
            .expand(
              (a) => a.findElements('landingCondition'),
            );

        crosswindValues = Map.fromEntries(
          target
              .expand(
                (condition) =>
                    condition.findAllElements('crosswindMAXvalue'),
              )
              .where((element) => element.getAttribute('id') != null)
              .map(
                (element) => MapEntry(
                  element.getAttribute('id')!,
                  element.innerText.trim(),
                ),
              ),
        );
      }

      return crosswindValues;
    } catch (e) {
      return {};
    }
  }
} 
