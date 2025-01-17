import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<Map<String, double>> getWeatherData(double latitude, double longitude) async {
    try {
      final uri = Uri.parse(
          '$baseUrl?latitude=$latitude&longitude=$longitude&current=pressure_msl&timezone=auto');
      
      print('Calling API: $uri'); // Pour le débogage
      
      final response = await http.get(uri);
      
      print('Response status: ${response.statusCode}'); // Pour le débogage
      print('Response body: ${response.body}'); // Pour le débogage

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Vérifier si les données nécessaires sont présentes
        if (data['current'] == null || 
            data['current']['pressure_msl'] == null) {
          throw Exception('Données manquantes dans la réponse API');
        }

        // Obtenir l'altitude via une seconde requête
        final elevationUri = Uri.parse(
            'https://api.open-meteo.com/v1/elevation?latitude=$latitude&longitude=$longitude');
        final elevationResponse = await http.get(elevationUri);
        
        if (elevationResponse.statusCode == 200) {
          final elevationData = json.decode(elevationResponse.body);
          final elevation = elevationData['elevation'][0].toDouble();

          return {
            'pressure': data['current']['pressure_msl'].toDouble(),
            'altitude': elevation,
          };
        } else {
          throw Exception('Erreur lors de la récupération de l\'altitude');
        }
      } else {
        throw Exception('Erreur API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erreur détaillée: $e'); // Pour le débogage
      throw Exception('Erreur lors de la récupération des données: $e');
    }
  }
} 