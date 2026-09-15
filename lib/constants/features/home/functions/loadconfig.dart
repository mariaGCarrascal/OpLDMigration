import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadconfig {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;

  Loadconfig({
    this.aircraftRef,
    this.landingRef,
    this.configurationRef,
  });

  List<String>? call() {
    final XmlDocument document = OpLdService.instance.document;
    final XmlDocument xmlDocument = document;
    List<String>? flapsNon;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;

    if (aircraftRef == null ||
        landingRef == null ||
        configurationRef == null) {
      return null;
    }

    try {
      Iterable<XmlElement> targetFlap = [];
  
      if (selectedAircraftType != null && selectedLandingType != null) {
        targetFlap = xmlDocument
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
        flapsNon = targetFlap
            .where((f) => f.getAttribute('id') == selectedConfigurationType)
            .map((e) => e.getAttribute('flapLabel'))
            .where((label) => label != null)
            .cast<String>()
            .toList();
      }

      return flapsNon;
    } catch (e) {
      return null;
    }
  }
}