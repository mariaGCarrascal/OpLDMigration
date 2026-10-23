import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadvreftext {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;

  Loadvreftext({
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
      return null;
    }

    try {
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .where(
            (a) =>
                a.getAttribute('id') == selectedAircraftType ||
                a.getAttribute('label') == selectedAircraftType,
          ).firstOrNull;

      if (aircraft == null) return null;

      final landingCondition = aircraft
          .findElements('landingCondition')
          .where(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLandingType.toUpperCase(),
          ).firstOrNull;

      if (landingCondition == null) return null;

      final nonNormalConfig = landingCondition
          .findElements('nonNormalConfiguration')
          .where((f) => f.getAttribute('id') == selectedConfigurationType).firstOrNull;

      if (nonNormalConfig == null) return null;

      return nonNormalConfig.getAttribute('VrefLabel');
    } catch (e) {
      return null;
    }
  }
}