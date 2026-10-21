import 'package:flutter_application_5/service_dataxml/opldservice.dart';
import 'package:xml/xml.dart';

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class Loadreversers {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;

  Loadreversers({
    this.aircraftRef,
    this.landingRef,
    this.configurationRef,
    this.flapRef,
    this.conditionRef,
  });

  List<String> call() {
    List<String> revsrInopData = [];
    List<String> reversers = [];
    String? nombre;
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedConfiguration = configurationRef;
    final String? selectedFlap = flapRef;
    final String? selectedCondition = conditionRef;

    try {

      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .firstWhereOrNull(
            (a) =>
                a.getAttribute('id') == selectedAircraft ||
                a.getAttribute('label') == selectedAircraft,
          );
      if (aircraft == null) return reversers = [];

      final landingCondition = aircraft
          .findElements('landingCondition')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLanding?.toUpperCase(),
          );
      if (landingCondition == null) return reversers = [];

      XmlElement? configNode;
      if (selectedLanding == 'Normal') {
        if (selectedFlap == null) return reversers = [];
        configNode = landingCondition
            .findElements('Flap')
            .firstWhereOrNull((f) => f.getAttribute('label') == selectedFlap);
      } else {
        if (selectedConfiguration == null) return reversers = [];
        configNode = landingCondition
            .findElements('nonNormalConfiguration')
            .firstWhereOrNull(
              (f) => f.getAttribute('id') == selectedConfiguration,
            );
      }
      if (configNode == null) return reversers = [];

      final brakingAction = configNode
          .findElements('reportedBrakingAction')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedCondition?.toUpperCase(),
          );
      if (brakingAction == null) return reversers = [];

      revsrInopData = brakingAction
          .findElements('ReverserInoperativeAdjustment')
          .map((node) => node.getAttribute('AmountOfRevInop'))
          .whereType<String>()
          .toList();

      for (int i = 0; i < revsrInopData.length; i++) {
        nombre = '${revsrInopData[i]} revsr Inop';
        reversers.add(nombre);
      }

      return reversers;
    } catch (e) {
      return reversers = [];
    }
  }
}