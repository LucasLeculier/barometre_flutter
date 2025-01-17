import 'dart:math' as math;

class WeatherData {
  final double pressure;
  final double altitude;
  final DateTime timestamp;

  WeatherData({
    required this.pressure,
    required this.altitude,
    required this.timestamp,
  });

  double get correctedPressure {
    return pressure * math.exp(altitude / 7400);
  }

  String getPressureStatus() {
    final p = correctedPressure;
    if (p < 1000) {
      return 'Basse pression - Temps instable probable';
    } else if (p > 1020) {
      return 'Haute pression - Beau temps probable';
    } else {
      return 'Pression normale';
    }
  }
} 