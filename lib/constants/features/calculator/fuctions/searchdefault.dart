import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Searchdefault {
  final String? aircraftRef;

  Searchdefault({this.aircraftRef});

  List<String> call() {
    final XmlDocument xmlDocument = OpLdService.instance.document;
    final String? selectedAircraftType = aircraftRef;

    if (selectedAircraftType == null) {
      return [];
    }

    try {
      final aircraft = xmlDocument
          .findAllElements('aircraft')
          .where(
            (a) =>
                a.getAttribute('id') == selectedAircraftType ||
                a.getAttribute('label') == selectedAircraftType,
          ).firstOrNull;

      if (aircraft == null) return [];

      final landingCondition = aircraft
          .findElements('landingCondition').firstOrNull;

      if (landingCondition == null) return [];

      const keys = [
        'VrefAdditiveDefaultValue',
        'flapDefaultLabel',
        'autobrakeSetting_id_ofDefault',
        'reportedBrakingAction_label_ofDefault',
        'weightDefaultValue',
        'weightMAXvalue',
        'weightMINvalue',
        'VrefAdditiveMINvalue',
        'VrefAdditiveMAXvalue',
        'altitudeMINvalue',
        'altitudeMAXvalue',
        'slopeMINvalue',
        'slopeMAXvalue',
        'deltaISA_MINvalue',
        'deltaISA_MAXvalue',
        'reversersInoperativeDefaultValue',
        'reversersInoperativeMINvalue',
        'reversersInoperativeMAXvalue',
        'altitudeDefaultValue',
        'reportedBrakingAction_label_ofDefault',
        'windDefaultValue',
        'windMINvalue',
        'windMAXvalue',
        'deltaISA_DefaultValue',
        'crosswindComments',
      ];

      final List<String> defaultValues = [];
      for (final key in keys) {
        for (final element in landingCondition.findAllElements(key)) {
          defaultValues.add(element.innerText.trim());
        }
      }

      return defaultValues;
    } catch (e) {
      return [];
    }
  }
}