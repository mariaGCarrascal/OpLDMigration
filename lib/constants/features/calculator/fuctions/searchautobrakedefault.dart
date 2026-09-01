import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Searchautobrakedefault {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? conditionRef;

  Searchautobrakedefault({
    this.aircraftRef,
    this.landingRef,
    this.configurationRef,
    this.conditionRef,
  });

  String? call() {
    final XmlDocument document = OpLdService.instance.document;
    final XmlDocument xmlDocument = document;
     String? autobrake;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;
    final String? selectedCondition = conditionRef;

    if (aircraftRef == null ||
        landingRef == null ||
        configurationRef == null ||
        conditionRef == null) {
      return null;
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
        autobrake = target
            .where((f) => f.getAttribute('id') == selectedConfigurationType)
            .expand((c) => c.findAllElements('reportedBrakingAction'))
            .where(
              (lc) =>
                  lc.getAttribute('label')?.toUpperCase() ==
                  selectedCondition!.toUpperCase(),
            )
            .map((c) => c.getAttribute('default_id_forNNautobrakeConfigSetting'))
            .whereType<String>()
            .firstOrNull;
      }

      return autobrake;
    } catch (e) {
      return null;
    }
  }
}