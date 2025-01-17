import 'package:flutter/material.dart';
import '../../models/weather_data.dart';
import '../painters/barometer_painter.dart';

class BarometerWidget extends StatelessWidget {
  final WeatherData? weatherData;
  final Animation<double> animation;

  const BarometerWidget({
    super.key,
    required this.weatherData,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(260, 260),
              painter: BarometerPainter(
                pressure: weatherData?.pressure ?? 1013,
                altitude: weatherData?.altitude ?? 0,
                progress: animation.value,
                theme: Theme.of(context),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        _buildInfoCard(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${weatherData?.pressure.toStringAsFixed(1)} hPa',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Altitude: ${weatherData?.altitude.toStringAsFixed(0)}m',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              weatherData?.getPressureStatus() ?? '',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Dernière mise à jour: ${weatherData != null ? '${weatherData!.timestamp.hour}:${weatherData!.timestamp.minute.toString().padLeft(2, '0')}' : '-'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
} 