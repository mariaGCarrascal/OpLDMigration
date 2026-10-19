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

class Slopedistancecalculation {

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? slopeRef;
  final Map<String, String>? baseDetails;

  Slopedistancecalculation({ 
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
    this.conditionRef, this.autobrakeRef, this.slopeRef, this.baseDetails
  });
    
  double call() {
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
      //Search upHill/downHill Slope Adjustment Value for SLOPE ADJ 
      double slope = double.tryParse(slopeRef ?? '') ?? 0;
      String nodeSlopeRef = slope >= 0
                          ? 'upHillSlopeAdjustment'
                          : 'downHillSlopeAdjustment';

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

      //Localizar el nodo de slope por el nombre del tag id
      final slopeAdjNode = brakingAction
          .findElements(nodeSlopeRef)
          .firstOrNull;
      if (slopeAdjNode == null) return 0;

      //Filtrar por autobrake
      final autobrake = slopeAdjNode
          .childElements
          .firstWhereOrNull(
            (child) =>
                child.getAttribute('id')?.toUpperCase() ==
                selectedautobrake?.toUpperCase(),
          );
      if (autobrake == null) return 0;

      //Obtener el valor slope
      double slopeAdjustment = 0;
      if (autobrake.childElements.isNotEmpty) {
        slopeAdjustment = double.tryParse(autobrake.childElements.first.innerText.trim()) ?? 0;
      } else {
        slopeAdjustment = double.tryParse(autobrake.innerText.trim()) ?? 0;
      }

      // Adjustment result value
      double selectedSlope = double.tryParse(slopeRef ?? '') ?? 0;
      double baseLineRefSlope = double.tryParse(baseDetails!['refSlope'] ?? '') ?? 0;
      double perHowManySlopeUnits = double.tryParse(baseDetails!['perHowManySlopeUnits'] ?? '') ?? 0;
      double slopeDifference = (selectedSlope - baseLineRefSlope).abs();

      result = ((slopeAdjustment / perHowManySlopeUnits) * slopeDifference);
      return result;

    } catch (e) {
      return 0; 
    }
  }
  
}