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

class Winddistancecalculation {

  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;
  final String? flapRef;
  final String? conditionRef;
  final String? autobrakeRef;
  final String? windRef;
  final Map<String, String>? baseDetails;

  Winddistancecalculation({ 
    this.aircraftRef, this.landingRef, this.configurationRef, this.flapRef, 
    this.conditionRef, this.autobrakeRef, this.windRef, this.baseDetails
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
      //Search headWind/tailWind Wind adjustment Value for WIND ADJ 
      double wind = double.tryParse(windRef ?? '') ?? 0;
      String nodeWindRef = wind >= 0
                          ? 'headWindAdjustment'
                          : 'tailWindAdjustment';

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

      //Localizar el nodo de viento por el tag id
      final windAdjNode = brakingAction
          .findElements(nodeWindRef)
          .firstOrNull;
      if (windAdjNode == null) return 0;

      //Filtrar por autobrake
      final autobrake = windAdjNode
          .childElements
          .firstWhereOrNull(
            (child) =>
                child.getAttribute('id')?.toUpperCase() ==
                selectedautobrake?.toUpperCase(),
          );
      if (autobrake == null) return 0;

      //Obtener valor del nodo 
      double windAdjustment = 0;
      if (autobrake.childElements.isNotEmpty) {
        windAdjustment = double.tryParse(autobrake.childElements.first.innerText.trim()) ?? 0;
      } else {
        windAdjustment = double.tryParse(autobrake.innerText.trim()) ?? 0;
      }

      // Operation for adjustment result
      double selectedWind = double.tryParse(windRef ?? '') ?? 0;
      double baseLineRefWind = double.tryParse(baseDetails!['refWind'] ?? '') ?? 0;
      double perHowManyWindSpeedUnits = double.tryParse(baseDetails!['perHowManyWindSpeedUnits'] ?? '') ?? 0;
      double windDifference = (selectedWind - baseLineRefWind).abs();

      result = ((windAdjustment / perHowManyWindSpeedUnits) * windDifference);
      return result;

    } catch (e) {
      return 0; 
    }
  }
  
}