import 'package:apiverve_airportcodeconverter/apiverve_airportcodeconverter.dart';

class AirportFormat {
  final AirportcodeconverterClient _client;

  // Permite pasar la API key al instanciar o usar una por defecto
  AirportFormat({String apiKey = 'YOUR_API_KEY'})
      : _client = AirportcodeconverterClient(apiKey);

  Future<String?> getIataCode(String airportQuery) async {
    try {
      final response = await _client.execute({
        'code': airportQuery,
      });

      if (response.status == 'ok' && response.data != null) {
        final dynamic rawData = response.data;

        if (rawData is Map<String, dynamic> && rawData.containsKey('iata')) {
          final String iataCode = rawData['iata']?.toString() ?? '';
          return iataCode;
        }
      }

      return null;
    } catch (e) {
      print('Error al consultar código de aeropuerto: $e');
      return null;
    }
  }
}