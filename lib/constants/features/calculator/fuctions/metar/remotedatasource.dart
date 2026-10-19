import 'package:flutter_application_5/constants/features/calculator/fuctions/metar/airportformat.dart';
import 'package:http/http.dart' as http;

class Remotedatasource {
  final http.Client client;
  final AirportFormat airportFormat;

  Remotedatasource({
    required this.client,
    AirportFormat? airportFormat,
  }) : airportFormat = airportFormat ?? AirportFormat();

  Future<String> getMetar(String airportCode) async {
    try {
      //Obtener el codigo IATA del aeropuerto
      final String? iataCode = await airportFormat.getIataCode(airportCode);

      //Si no se encuentra el codigo o viene vacio, se usara el codigo original del aeropuerto
      final String targetCode = (iataCode != null && iataCode.isNotEmpty) 
          ? iataCode 
          : airportCode;

      final response = await client.get(
        Uri.parse('https://aviationweather.gov/api/data/metar?ids=$targetCode'),
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.isEmpty) {
          throw Exception("No METAR data found for $targetCode");
        }
        return body;
      } else {
        throw Exception("Failed to load metar. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching METAR: $e");
    }
  }
}