import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class Loadautobrakes {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;

  Loadautobrakes({
    this.aircraftRef,
    this.landingRef,
    this.configurationRef,
    this.flapRef,
    this.conditionRef,
  });

  List<String> call() {
    List<String> autobrakesSettings = [];
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;
    final String? selectedflap = flapRef;
    final String? selectedCondition = conditionRef;

    try {
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .firstWhereOrNull(
            (a) =>
                a.getAttribute('id') == selectedAircraftType ||
                a.getAttribute('label') == selectedAircraftType,
          );
      if (aircraft == null) return autobrakesSettings = [];

      final landingCondition = aircraft
          .findElements('landingCondition')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLandingType?.toUpperCase(),
          );
      if (landingCondition == null) return autobrakesSettings = [];

      XmlElement? configNode;
      if (selectedLandingType == 'Normal') {
        if (selectedflap == null) return autobrakesSettings = [];
        configNode = landingCondition
            .findElements('Flap')
            .firstWhereOrNull((f) => f.getAttribute('label') == selectedflap);
      } else {
        if (selectedConfigurationType == null) return autobrakesSettings = [];
        configNode = landingCondition
            .findElements('nonNormalConfiguration')
            .firstWhereOrNull(
              (f) => f.getAttribute('id') == selectedConfigurationType,
            );
      }
      if (configNode == null) return autobrakesSettings = [];

      final brakingAction = configNode
          .findElements('reportedBrakingAction')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedCondition?.toUpperCase(),
          );
      if (brakingAction == null) return autobrakesSettings = [];

      final refDistance = brakingAction
          .findElements('refDistance')
          .firstOrNull;
      if (refDistance == null) return autobrakesSettings = [];

      autobrakesSettings = refDistance.childElements
          .map((child) => child.getAttribute('id'))
          .whereType<String>()
          .toList();

      return autobrakesSettings;
    } catch (e) {
      return autobrakesSettings = [];
    }
  }
}