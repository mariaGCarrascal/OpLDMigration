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

class Searchbaselinereference {

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;

  Searchbaselinereference({ 
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef
  });
    
  Map<String, String> call() {
    Map<String, String> baseReference = {};
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedConfiguration = configurationRef;
    final String? selectedflap = flapRef;

    if (aircraftRef == null || landingRef == null) {
      return baseReference = {};
    }

    try {
      //Filtrar por aircraft
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .firstWhereOrNull(
            (a) =>
                a.getAttribute('id') == selectedAircraft ||
                a.getAttribute('label') == selectedAircraft,
          );
      if (aircraft == null) return baseReference = {};

      //Filtrar por landing condition
      final landingCondition = aircraft
          .findElements('landingCondition')
          .firstWhereOrNull(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLanding?.toUpperCase(),
          );
      if (landingCondition == null) return baseReference = {};

      //Filtrar si es por flaps o configuration
      XmlElement? configNode;
      if (selectedLanding == 'Normal') {
        if (selectedflap == null) return baseReference = {};
        configNode = landingCondition
            .findElements('Flap')
            .firstWhereOrNull((f) => f.getAttribute('label') == selectedflap);
      } else {
        if (selectedConfiguration == null) return baseReference = {};
        configNode = landingCondition
            .findElements('nonNormalConfiguration')
            .firstWhereOrNull(
                (f) => f.getAttribute('id') == selectedConfiguration);
      }
      if (configNode == null) return baseReference = {};

      //Localizar el nodo baselineReferenceDetails
      final baselineDetails = configNode
          .findElements('baselineReferenceDetails')
          .firstOrNull;
      if (baselineDetails == null) return baseReference = {};

      //Obtener los valores de los nodos hijos
      for (final refGroup in baselineDetails.childElements) {
        for (final item in refGroup.childElements) {
          baseReference[item.name.local] = item.innerText.trim();
        }
      }
     
      return baseReference;

    } catch (e) {
      return baseReference = {}; 
    }
  }
  
}