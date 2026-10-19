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

class Altitudedistancecalculation {

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? altitudeRef;
  final Map<String, String>? baseDetails;

  Altitudedistancecalculation({ 
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
    this.conditionRef, this.autobrakeRef, this.altitudeRef, this.baseDetails
  });
    
  double call() {
    Map<String, String> altitudeData = {};
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

      //Localizar el nodo altitudeAdjustment
      final altitudeAdjustment = brakingAction
          .findElements('altitudeAdjustment')
          .firstOrNull;
      if (altitudeAdjustment == null) return 0;

      //Filtrar por autobrake 
      final autobrake = altitudeAdjustment
          .childElements
          .firstWhereOrNull(
            (child) =>
                child.getAttribute('id')?.toUpperCase() ==
                selectedautobrake?.toUpperCase(),
          );

      //Obtener las claves y valores hijos directamente
      if (autobrake != null) {
        for (final child in autobrake.childElements) {
          altitudeData[child.name.local] = child.innerText.trim();
        }
      }

      //Operation for adjustement result
      double selectedAltitude = double.tryParse(altitudeRef ?? '') ?? 0;
      double aboveSwitchAlt = double.tryParse(altitudeData['aboveSwitchAlt'] ?? '') ?? 0;
      double belowSwitchAlt = double.tryParse(altitudeData['belowSwitchAlt'] ?? '') ?? 0;
      double baseLineRefAlt = double.tryParse(baseDetails!['refAlt'] ?? '') ?? 0;
      double perHowManyAltUnits = double.tryParse(baseDetails!['perHowManyAltUnits'] ?? '') ?? 0;
      double switchAlt = double.tryParse(baseDetails!['switchAlt'] ?? '') ?? 0;

      if (selectedAltitude <= switchAlt) {
        double altitudeDifference = selectedAltitude - baseLineRefAlt;
        result = ((belowSwitchAlt / perHowManyAltUnits) * altitudeDifference);

      } else if (selectedAltitude > switchAlt) {
        double altitudeDifference = selectedAltitude - switchAlt;
        result = ((belowSwitchAlt / perHowManyAltUnits) * switchAlt) + ((aboveSwitchAlt / perHowManyAltUnits) * altitudeDifference);

      } else {
        result = double.nan;
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
}