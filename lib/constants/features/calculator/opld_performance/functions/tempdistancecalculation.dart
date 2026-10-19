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

class Tempdistancecalculation {

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? isaRef;
  final Map<String, String>? baseDetails;

  Tempdistancecalculation({ 
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
    this.conditionRef, this.autobrakeRef, this.isaRef, this.baseDetails
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
      //Search aboveISA/belowISA Temperature adjustment Value for TEMP ADJ 
      double isa = double.tryParse(isaRef ?? '') ?? 0;
      String nodeIsaRef = isa >= 0
                          ? 'aboveISAtempAdjustment'
                          : 'belowISAtempAdjustment';

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

      //Localizar el nodo de isatempadjusment por tag id
      final tempAdjNode = brakingAction
          .findElements(nodeIsaRef)
          .firstOrNull;
      if (tempAdjNode == null) return 0;

      //Filtrar por autobrake
      final autobrake = tempAdjNode
          .childElements
          .firstWhereOrNull(
            (child) =>
                child.getAttribute('id')?.toUpperCase() ==
                selectedautobrake?.toUpperCase(),
          );
      if (autobrake == null) return 0;

      //Obtener el valor isa de temperatura
      double tempAdjustment = 0;
      if (autobrake.childElements.isNotEmpty) {
        tempAdjustment = double.tryParse(autobrake.childElements.first.innerText.trim()) ?? 0;
      } else {
        tempAdjustment = double.tryParse(autobrake.innerText.trim()) ?? 0;
      }

      // Operation for adjustment result
      double selectedISA = double.tryParse(isaRef ?? '') ?? 0;
      double baseLineRefISATemp = double.tryParse(baseDetails!['refDltaISA'] ?? '') ?? 0;
      double perHowManyTempUnits = double.tryParse(baseDetails!['perHowManyTempUnits'] ?? '') ?? 0;
      double isaDifference = (selectedISA - baseLineRefISATemp).abs();

      result = ((tempAdjustment / perHowManyTempUnits) * isaDifference);
      return result;

    } catch (e) {
      return 0; 
    }
  }
  
}