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
    final XmlDocument xmlDocument = OpLdService.instance.document;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;

    if (selectedAircraftType == null ||
        selectedLandingType == null ||
        selectedConfigurationType == null) {
      return 'NO';
    }

    try {
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .where(
            (a) =>
                a.getAttribute('id') == selectedAircraftType ||
                a.getAttribute('label') == selectedAircraftType,
          ).firstOrNull;

      if (aircraft == null) return 'NO';

      final landingCondition = aircraft
          .findElements('landingCondition')
          .where(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLandingType.toUpperCase(),
          ).firstOrNull;

      if (landingCondition == null) return 'NO';

      final nonNormalConfig = landingCondition
          .findElements('nonNormalConfiguration')
          .where((f) => f.getAttribute('id') == selectedConfigurationType).firstOrNull;

      if (nonNormalConfig == null) return 'NO';

      final vrefNode = nonNormalConfig
          .findElements('NonNrmlVREFAdjustmentsExist_YESorNO').firstOrNull;

      if (vrefNode == null) return 'NO';

      return vrefNode.innerText.trim();
    } catch (e) {
      return 'NO';
    }
  }
}