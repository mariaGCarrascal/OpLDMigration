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

class Loadcomments {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;

  Loadcomments({
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef,
  });

  List<String> call() {
    List<String> comentarios = [];
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;
    final String? selectedflap = flapRef;

    try {
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .firstWhereOrNull(
            (a) =>
                a.getAttribute('id') == selectedAircraftType ||
                a.getAttribute('label') == selectedAircraftType,
          );
      if (aircraft == null) return comentarios = [];

      final landingCondition = aircraft
          .findElements('landingCondition')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLandingType?.toUpperCase(),
          );
      if (landingCondition == null) return comentarios = [];

      XmlElement? configNode;
      if (selectedLandingType == 'Normal') {
        if (selectedflap == null) return comentarios = [];
        configNode = landingCondition
            .findElements('Flap')
            .firstWhereOrNull((f) => f.getAttribute('label') == selectedflap);
      } else {
        if (selectedConfigurationType == null) return comentarios = [];
        configNode = landingCondition
            .findElements('nonNormalConfiguration')
            .firstWhereOrNull(
              (f) => f.getAttribute('id') == selectedConfigurationType,
            );
      }
      if (configNode == null) return comentarios = [];

      comentarios = configNode
          .findElements('Comments')
          .map((e) => e.innerText.trim())
          .toList();

      return comentarios;
    } catch (e) {
      return comentarios = [];
    }
  }
}