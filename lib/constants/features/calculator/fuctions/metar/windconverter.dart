class Windconverter {
  static List<String> parseWind(String windRaw) {
    if (windRaw.isEmpty) return ['', ''];

    var cleanWind = windRaw.trim().toUpperCase();

    if (cleanWind.endsWith('KT')) {
      cleanWind = cleanWind.substring(0, cleanWind.length - 2);
    } else if (cleanWind.endsWith('MPS')) {
      cleanWind = cleanWind.substring(0, cleanWind.length - 3);
    }

    //Validacion vientos calmados, 00000KT -> 000 y 0
    if (cleanWind == '00000') {
      return ['000', '0'];
    }

    //Si empieza por VRB (viento variable), la direccion del viento sera 000 y el nodo sera 0
    if (cleanWind.startsWith('VRB')) {
      return ['000', '0'];
    }

    //Si contiene rafagas de viento (G), usar solo lo que esta antes de G
    if (cleanWind.contains('G')) {
      cleanWind = cleanWind.split('G')[0];
    }

    //Las 3 primeras cifras son la direccion del viento, el resto es el nodo
    if (cleanWind.length >= 5) {
      final direction = cleanWind.substring(0, 3);
      final rawNode = cleanWind.substring(3);

      //Eliminar ceros a la izquierda del nodo de viento (ej: 05 -> 5)
      final speed = int.tryParse(rawNode)?.toString() ?? rawNode;

      return [direction, speed];
    }

    return ['', ''];
  }
}