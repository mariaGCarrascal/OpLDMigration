import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/oatconverter.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/qnhconverter.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/windconverter.dart';

class MetarParser {
  static Map<String, String> parseMetar(String rawMetar) {
    //Regex para vientos (ej: 13011KT, 00000KT, VRB05KT o 24015G25KT)
    final windRegex = RegExp(r'\b(?:\d{3}|VRB)\d{2,3}(?:G\d{2,3})?KT\b');

    //Regex para temperatura/punto de rocio (ej: 30/14 o M02/M05)
    final tempRegex = RegExp(r'\bM?\d{2}/M?\d{2}\b');

    //Regex para presion/altimetro del qnh (ej: Q1020 o A2992)
    final qnhRegex = RegExp(r'\b[QA]\d{4}\b');

    final windMatch = windRegex.firstMatch(rawMetar)?.group(0) ?? '';
    final oatMatch = tempRegex.firstMatch(rawMetar)?.group(0) ?? '';
    final qnhMatch = qnhRegex.firstMatch(rawMetar)?.group(0) ?? '';

    //Adaptar variables del Metar para el OpLD
    final windValues = Windconverter.parseWind(windMatch);
    final oat = OatConverter.toCelsius(oatMatch)?.toString() ?? '';
    final qnh = Qnhconverter.toQnhString(qnhMatch);

    return {
      'WIND': windValues[0].trim(),
      'NODE': windValues[1].trim(),
      'OAT': oat.trim(),
      'QNH': qnh.trim(),
      'INFO': rawMetar,
    };
  }
}