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
    final XmlDocument xmlDocument = OpLdService.instance.document;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;
    final String? selectedCondition = conditionRef;

    if (selectedAircraftType == null ||
        selectedLandingType == null ||
        selectedConfigurationType == null ||
        selectedCondition == null) {
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

      final brakingAction = nonNormalConfig
          .findElements('reportedBrakingAction')
          .where(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedCondition.toUpperCase(),
          ).firstOrNull;

      if (brakingAction == null) return null;

      return brakingAction.getAttribute('default_id_forNNautobrakeConfigSetting');
    } catch (e) {
      return null;
    }
  }
}