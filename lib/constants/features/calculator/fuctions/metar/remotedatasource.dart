import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/metarparser.dart';
import 'package:flutter_application_5/constants/features/home/data/airportdata.dart';
import 'package:http/http.dart' as http;

class Remotedatasource {
  final http.Client client;

  Remotedatasource({
    required this.client,
  });

  Future<Map<String, String>> getMetar(String airportCode) async {
    try {
      Map<String, String> metar = {};
      //Obtener el codigo ICAO del aeropuerto seleccionado
      final String? airport = Airportdata.airportIcao[airportCode];

      //Si no se encuentra el codigo ICAO, se usara el codigo IATA del aeropuerto
      final String targetCode = (airport != null && airport.isNotEmpty) 
          ? airport 
          : airportCode;

      final response = await client.get(
        Uri.parse('https://aviationweather.gov/api/data/metar?ids=$targetCode'),
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();
        metar = MetarParser.parseMetar(body);

        if (body.isEmpty) {
          throw Exception("No METAR data found for $targetCode");
        }
        return metar;
      } else {
        throw Exception("Failed to load metar. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching METAR: $e");
    }
  }
}