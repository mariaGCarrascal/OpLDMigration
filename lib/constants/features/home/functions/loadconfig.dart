import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Loadconfig {
  final String? aircraftRef;

  Loadconfig({
    this.aircraftRef
  });

  List<String> call() {
    final XmlDocument document = OpLdService.instance.document;
    final XmlDocument xmlDocument = document;
    List<String> configurationTypes = [];
    final String? selectedAircraftType = aircraftRef;

    if (aircraftRef == null) {
      return configurationTypes = [];
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


      final nonNormalLanding = aircraft!
          .findElements('landingCondition')
          .where((lc) => lc.getAttribute('label')?.toUpperCase() == 'NON-NORMAL')
          .firstOrNull;

      configurationTypes = nonNormalLanding!
          .findElements('nonNormalConfiguration')
          .map((e) => e.getAttribute('id'))
          .whereType<String>()
          .toSet()
          .toList();

      return configurationTypes;
    } catch (e) {
      return configurationTypes = [];
    }
  }
}