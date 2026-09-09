import 'package:xml/xml.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';

class Tempdistancecalculation{

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
    Map<String, String> tempData = {};
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
      Iterable<XmlElement> target = [];
      double isa = double.tryParse(isaRef ?? '') ?? 0;
      String nodeIsaRef = isa >= 0
                        ? 'aboveISAtempAdjustment'
                        : 'belowISAtempAdjustment';
      String nodeIdRef = isa >= 0
                        ? 'ABOVE ISA TEMP ADJ'
                        : 'BLW ISA TEMP ADJ';

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
            tempData =  {
            for (final child in target
                .where((f) => f.getAttribute('label') == selectedflap)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements(nodeIsaRef))
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
            tempData = {
            for (final child in target
                .where((f) => f.getAttribute('id') == selectedConfiguration)
                .expand((c) => c.findAllElements('reportedBrakingAction'))
                .where(
                  (lc) =>
                      lc.getAttribute('label')?.toUpperCase() ==
                      selectedCondition!.toUpperCase(),
                )
                .expand((c) => c.findAllElements(nodeIsaRef))
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
      print('Resultado de busqueda en temperatura en caso $nodeIsaRef: $tempData');
      //Operation for adjustement result
      double selectedISA = double.tryParse(isaRef ?? '') ?? 0;
      double tempAdjustment = double.tryParse(tempData[tempData.keys.first] ?? '') ?? 0;     
      double baseLineRefISATemp = double.tryParse(baseDetails!['refDltaISA'] ?? '') ?? 0;
      double perHowManyTempUnits = double.tryParse(baseDetails!['perHowManyTempUnits'] ?? '') ?? 0;

      if (selectedISA < baseLineRefISATemp) {
        double isaDifference = baseLineRefISATemp - selectedISA;
        result = ((tempAdjustment / perHowManyTempUnits) * isaDifference);

      } else {
        double isaDifference = selectedISA - baseLineRefISATemp;
        result = ((tempAdjustment / perHowManyTempUnits) * isaDifference);

      }

      return result;

    } catch (e) {
      return 0; 
    }
  }
  
} 
