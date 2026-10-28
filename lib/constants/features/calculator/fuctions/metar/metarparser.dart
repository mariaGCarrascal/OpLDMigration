import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/oatconverter.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/qnhconverter.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/windconverter.dart';

class MetarParser {
  static bool _hasMissingSlashes(String value) => value.contains('//');

  static Map<String, String> parseMetar(String rawMetar) {
    final tokens = rawMetar.trim().split(RegExp(r'\s+'));

    String rawWind = '';
    String rawOat = '';
    String rawQnh = '';

    //Vientos: termina en KT (o MPS), puede ser digitos, VRB o barras
    final windTokenRegex = RegExp(r'^(?:\d{3}|VRB|/{3})(?:\d{2,3}|/{2,3})(?:G(?:\d{2,3}|/{2,3}))?KT$');
    
    //Temperatura: formato XX/XX donde X puede ser digito, M o /
    final tempTokenRegex = RegExp(r'^(?:M?\d{2}|/{2})/(?:M?\d{2}|/{2})$');
    
    //QNH: empieza por Q o A seguido de 4 digitos o 4 barras
    final qnhTokenRegex = RegExp(r'^[QA](?:\d{4}|/{4})$');

    for (final token in tokens) {
      if (rawWind.isEmpty && (token.endsWith('KT') || token.endsWith('MPS'))) {
        if (windTokenRegex.hasMatch(token) || token.contains('KT')) {
          rawWind = token;
        }
      } else if (rawOat.isEmpty && token.contains('/') && !token.contains('KT')) {
        if (tempTokenRegex.hasMatch(token)) {
          rawOat = token;
        }
      } else if (rawQnh.isEmpty && (token.startsWith('Q') || token.startsWith('A'))) {
        if (qnhTokenRegex.hasMatch(token)) {
          rawQnh = token;
        }
      }
    }

    final bool hasMissingData = _hasMissingSlashes(rawWind) ||
        _hasMissingSlashes(rawOat) ||
        _hasMissingSlashes(rawQnh) ||
        rawMetar.contains('//');

    final windMatch = _hasMissingSlashes(rawWind) ? '' : rawWind;
    final oatMatch = _hasMissingSlashes(rawOat) ? '' : rawOat;
    final qnhMatch = _hasMissingSlashes(rawQnh) ? '' : rawQnh;

    List<String> windValues = ['', ''];
    if (windMatch.isNotEmpty) {
      try {
        windValues = Windconverter.parseWind(windMatch);
      } catch (_) {
        windValues = ['', ''];
      }
    }

    String oat = '';
    if (oatMatch.isNotEmpty) {
      try {
        oat = OatConverter.toCelsius(oatMatch)?.toString() ?? '';
      } catch (_) {
        oat = '';
      }
    }

    String qnh = '';
    if (qnhMatch.isNotEmpty) {
      try {
        qnh = Qnhconverter.toQnhString(qnhMatch);
      } catch (_) {
        qnh = '';
      }
    }

    return {
      'WIND': windValues.isNotEmpty ? windValues[0].trim() : '',
      'NODE': windValues.length > 1 ? windValues[1].trim() : '',
      'OAT': oat.isNotEmpty ? oat.trim() : '',
      'QNH': qnh.isNotEmpty ? qnh.trim() : '',
      'INFO': rawMetar,
      'HAS_MISSING_DATA': hasMissingData.toString(),
      'IS_VALID': (!hasMissingData).toString(),
    };
  }
}