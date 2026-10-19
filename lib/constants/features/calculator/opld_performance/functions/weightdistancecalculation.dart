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

class Weightdistancecalculation {

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? weightRef;
  final Map<String, String>? baseDetails;

  Weightdistancecalculation({ 
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
    this.conditionRef, this.autobrakeRef, this.weightRef, this.baseDetails
  });
    
  double call() {
    Map<String, String> weightData = {};
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

      //Localizar el nodo weightAdjustment
      final weightAdjustment = brakingAction
          .findElements('weightAdjustment')
          .firstOrNull;
      if (weightAdjustment == null) return 0;

      //Fltrar por autobrake
      final autobrake = weightAdjustment
          .childElements
          .firstWhereOrNull(
            (child) =>
                child.getAttribute('id')?.toUpperCase() ==
                selectedautobrake?.toUpperCase(),
          );

      //Obtener las claves y valores de los nodos hijos 
      if (autobrake != null) {
        for (final child in autobrake.childElements) {
          weightData[child.name.local] = child.innerText.trim();
        }
      }

      //Operation for adjustement result
      double selectedWeight = double.tryParse(weightRef ?? '') ?? 0;
      double aboveRefWgtValue = double.tryParse(weightData['aboveRefWgt'] ?? '') ?? 0;
      double belowRefWgtValue = double.tryParse(weightData['belowRefWgt'] ?? '') ?? 0;
      double baseLineRefWeight = double.tryParse(baseDetails!['refWgt'] ?? '') ?? 0;
      double perHowManyWgtUnits = double.tryParse(baseDetails!['perHowManyWgtUnits'] ?? '') ?? 0;

      if (selectedWeight < baseLineRefWeight) {
        double weightDifference = baseLineRefWeight - selectedWeight;

        result = ((belowRefWgtValue / perHowManyWgtUnits) * weightDifference);

      } else if (selectedWeight > baseLineRefWeight) {

        double weightDifference = selectedWeight - baseLineRefWeight;

        result = ((aboveRefWgtValue / perHowManyWgtUnits) * weightDifference);

      } else {
        result = 0;
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
}