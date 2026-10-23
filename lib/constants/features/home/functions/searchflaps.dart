import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Searchflaps {
  final String? aircraftRef;
  final String? landingRef;
  final String? configurationRef;

  Searchflaps({
    this.aircraftRef,
    this.landingRef,
    this.configurationRef,
  });

  List<String> call() {
    final XmlDocument document = OpLdService.instance.document;
    final XmlDocument xmlDocument = document;
    List<String>? flapsNon = [];
    final String? selectedAircraftType = aircraftRef;
    final String? selectedLandingType = landingRef;
    final String? selectedConfigurationType = configurationRef;

    if (aircraftRef == null ||
        landingRef == null ||
        configurationRef == null) {
      return flapsNon = [];
    }

    try {
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .where(
            (a) =>
                a.getAttribute('id') == selectedAircraftType ||
                a.getAttribute('label') == selectedAircraftType,
          )
          .firstOrNull;
  

      final landingCondition = aircraft!
          .findElements('landingCondition')
          .where(
            (lc) =>
                lc.getAttribute('label')?.toUpperCase() ==
                selectedLandingType!.toUpperCase(),
          )
          .firstOrNull;


      final nonNormalConfig = landingCondition!
          .findElements('nonNormalConfiguration')
          .where((f) => f.getAttribute('id') == selectedConfigurationType)
          .firstOrNull;

      final flapLabel = nonNormalConfig!.getAttribute('flapLabel');
      if (flapLabel != null) {
        flapsNon = [flapLabel];
      }
 
      return flapsNon;

    } catch (e) {
      return flapsNon = [];
    }
  }
}