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

class Refdistancereference {

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final Map<String, String>? baseDetails;

  Refdistancereference({ 
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
    this.conditionRef, this.autobrakeRef, this.baseDetails
  });
    
  double call() {
    Map<String, String> distanceData = {};
    double result;
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedConfiguration = configurationRef;
    final String? selectedflap = flapRef;
    final String? selectedCondition = conditionRef;
    final String? selectedautobrake = autobrakeRef;

    try {
      //Filtrar por aircraft
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .firstWhereOrNull(
            (a) =>
                a.getAttribute('id') == selectedAircraft ||
                a.getAttribute('label') == selectedAircraft,
          );
      if (aircraft == null) return 0;

      //Filtrar por landing condition 
      final landingCondition = aircraft
          .findElements('landingCondition')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLanding?.toUpperCase(),
          );
      if (landingCondition == null) return 0;

      //Filtrar si es por flaps o configuration
      XmlElement? configNode;
      if (selectedLanding == 'Normal') {
        if (selectedflap == null) return 0;
        configNode = landingCondition
            .findElements('Flap')
            .firstWhereOrNull((f) => f.getAttribute('label') == selectedflap);
      } else {
        if (selectedConfiguration == null) return 0;
        configNode = landingCondition
            .findElements('nonNormalConfiguration')
            .firstWhereOrNull(
                (f) => f.getAttribute('id') == selectedConfiguration);
      }
      if (configNode == null) return 0;

      //Filtrar por runway condition 
      final brakingAction = configNode
          .findElements('reportedBrakingAction')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedCondition?.toUpperCase(),
          );
      if (brakingAction == null) return 0;

      //Localizar el nodo refDistance
      final refDistance = brakingAction
          .findElements('refDistance')
          .firstOrNull;
      if (refDistance == null) return 0;

      //Filtrar por autobrake
      final autobrake = refDistance
          .childElements
          .firstWhereOrNull(
            (child) =>
                child.getAttribute('id')?.toUpperCase() ==
                selectedautobrake?.toUpperCase(),
          );
      if (autobrake == null) return 0;

      //Obtener el valor tanto si es el texto directo como si tuviera nodos hijos
      if (autobrake.childElements.isNotEmpty) {
        for (final child in autobrake.childElements) {
          distanceData[child.name.local] = child.innerText.trim();
        }
        result = double.tryParse(distanceData[distanceData.keys.first] ?? '') ?? 0;
      } else {
        result = double.tryParse(autobrake.innerText.trim()) ?? 0;
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
}