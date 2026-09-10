import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadvrefcondition {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;

  Loadvrefcondition({
    this.aircraftRef,
    this.landingRef,
    this.configurationRef,
  });

  String? call() {
    final XmlDocument document = OpLdService.instance.document;
    final XmlDocument xmlDocument = document;
    String? vrefCond;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;


    if (aircraftRef == null ||
        landingRef == null ||
        configurationRef == null) {
      return 'NO';
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
        vrefCond = target
            .where((f) => f.getAttribute('id') == selectedConfigurationType)
            .expand((f) => f.findAllElements('NonNrmlVREFAdjustmentsExist_YESorNO'))
            .map((c) => c.innerText.trim())
            .where((text) => text.isNotEmpty)
            .firstOrNull;
      }

      return vrefCond;
    } catch (e) {
      return 'NO';
    }
  }
}