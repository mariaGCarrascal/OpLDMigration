import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Slopedistancecalculation{

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
    Map<String, String> hillsData = {};
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
      Iterable<XmlElement> target = [];
      double slope = double.tryParse(slopeRef ?? '') ?? 0;
      String nodeSlopeRef = slope >= 0
                        ? 'upHillSlopeAdjustment'
                        : 'downHillSlopeAdjustment';
      String nodeIdRef = slope >= 0
                        ? 'UP HILL SLOPE ADJ'
                        : 'DOWN HILL SLOPE ADJ';

      if(selectedLanding == 'Normal') {

          if (selectedAircraft != null && selectedLanding != null) {
            target = xmlDocument
                .findAllElements('aircraft')
                .where(
                  (a) =>
                      a.getAttribute('id') == selectedAircraft ||
                      a.getAttribute('label') == selectedAircraft,
                )
                .expand((l) => l.findAllElements('landingCondition'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedLanding.toUpperCase(),
                )
                .expand((f) => f.findAllElements('Flap'));
          }
          
          if (selectedflap != null) {
            hillsData =  {
            for (final child in target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements(nodeSlopeRef))
                .where(
                  (lc) =>
                      lc.getAttribute('id')?.toUpperCase() ==
                      nodeIdRef.toUpperCase(),
                )
                .expand((c) => c.children.whereType<XmlElement>())
                .where(
                  (child) =>
                      child.getAttribute('id')?.toUpperCase() ==
                      selectedautobrake!.toUpperCase(),
                ))
              child.name.local: child.innerText.trim(),
          };

          }


      } else {

        if (selectedAircraft != null && selectedLanding != null) {
            target = xmlDocument
                .findAllElements('aircraft')
                .where(
                  (a) =>
                      a.getAttribute('id') == selectedAircraft ||
                      a.getAttribute('label') == selectedAircraft,
                )
                .expand((l) => l.findAllElements('landingCondition'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedLanding.toUpperCase(),
                )
                .expand((f) => f.findAllElements('nonNormalConfiguration'));
          }
          
          if (selectedConfiguration != null) {
            hillsData = {
            for (final child in target
                .where((f) => f.getAttribute('id') == selectedConfiguration)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements(nodeSlopeRef))
                .where(
                  (lc) =>
                      lc.getAttribute('id')?.toUpperCase() ==
                      nodeIdRef.toUpperCase(),
                )
                .expand((c) => c.children.whereType<XmlElement>())
                .where(
                  (child) =>
                      child.getAttribute('id')?.toUpperCase() ==
                      selectedautobrake!.toUpperCase(),
                ))
              child.name.local: child.innerText.trim(),
          };

          }
        }
      print('Resultado de busqueda en slopes en caso $nodeSlopeRef: $hillsData');
      //Adjustement result value
      double selectedSlope = double.tryParse(slopeRef ?? '') ?? 0;
      double slopeAdjustment = double.tryParse(hillsData['$selectedautobrake'] ?? '') ?? 0;     
      double baseLineRefSlope = double.tryParse(baseDetails!['refSlope'] ?? '') ?? 0;
      double perHowManySlopeUnits = double.tryParse(baseDetails!['perHowManySlopeUnits'] ?? '') ?? 0;

      if (selectedSlope < baseLineRefSlope) {
        double slopeDifference = baseLineRefSlope - selectedSlope;
        result = ((slopeAdjustment / perHowManySlopeUnits) * slopeDifference);

      } else {
        double slopeDifference = selectedSlope - baseLineRefSlope;
        result = ((slopeAdjustment / perHowManySlopeUnits) * slopeDifference);
      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
