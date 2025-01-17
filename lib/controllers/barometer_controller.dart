import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../models/weather_data.dart';

class BarometerController extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  
  WeatherData? weatherData;
  bool isLoading = false;
  String error = '';

  Future<void> getCurrentPressure() async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      // Obtenir la position via le service de localisation
      final position = await _locationService.getCurrentLocation();

      // Obtenir les données météo
      final data = await _weatherService.getWeatherData(
        position.latitude,
        position.longitude,
      );

      weatherData = WeatherData(
        pressure: data['pressure']!,
        altitude: data['altitude']!,
        timestamp: DateTime.now(),
      );
      isLoading = false;
      notifyListeners();
      
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      isLoading = false;
      notifyListeners();
    }
  }
} 