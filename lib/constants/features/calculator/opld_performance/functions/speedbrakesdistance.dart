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

class Speedbrakesdistance {

  final String? aircraftRef;
  final String? landingRef;
  final String? flapRef;
  final String? autobrakeRef;
  final String? speedbrakeRef;
  final Map<String, String>? baseDetails;

  Speedbrakesdistance({ 
    this.aircraftRef, this.landingRef, this.flapRef, 
    this.autobrakeRef, this.speedbrakeRef, this.baseDetails
  });
    
  double call() {
    Map<String, String> brakesData = {};
    double result;
    final XmlDocument document = OpLdService.instance.document;
    XmlDocument? xmlDocument;
    xmlDocument = document;
    final String? selectedAircraft = aircraftRef;
    final String? selectedLanding = landingRef;
    final String? selectedflap = flapRef;
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

      //Filtrar por flap seleccionado
      if (selectedLanding == 'Normal' && selectedflap != null && speedbrakeRef != null) {
        final flapNode = landingCondition
            .findElements('Flap')
            .firstWhereOrNull((f) => f.getAttribute('label') == selectedflap);
        if (flapNode == null) return 0;

        //Localizar el nodo SpeedBrakesAdjustment
        final speedBrakesAdj = flapNode
            .findElements('SpeedBrakesAdjustment')
            .firstWhereOrNull(
              (lc) =>
                  lc.getAttribute('label')?.toUpperCase() ==
                  speedbrakeRef!.toUpperCase(),
            );
        if (speedBrakesAdj == null) return 0;

        //Filtrar por autobrake
        final autobrake = speedBrakesAdj
            .childElements
            .firstWhereOrNull(
              (child) =>
                  child.getAttribute('id')?.toUpperCase() ==
                  selectedautobrake?.toUpperCase(),
            );

        //Obtener el valor de speedbrakes
        if (autobrake != null) {
          if (autobrake.childElements.isNotEmpty) {
            result = double.tryParse(autobrake.childElements.first.innerText.trim()) ?? 0;
          } else {
            result = double.tryParse(autobrake.innerText.trim()) ?? 0;
          }
        }
      }

       print('Busqueda de speedbrakes en el xml: $brakesData');
      
      //Adjustement result
      if (selectedLanding == 'Non-Normal') {
        result = 0;
      } else {
        result = double.tryParse(brakesData[brakesData.keys.first] ?? '0') ?? 0;     
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
}