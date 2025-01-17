import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'weather_condition.dart';

class BarometerPainter extends CustomPainter {
  final double pressure;
  final double altitude;
  final double progress;
  final ThemeData theme;

  BarometerPainter({
    required this.pressure,
    required this.altitude,
    required this.progress,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    
    // Dessiner l'arc de fond
    final backgroundPaint = Paint()
      ..color = theme.colorScheme.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      backgroundPaint,
    );

    // Calculer la valeur normalisée de la pression (950-1050 hPa)
    final normalizedPressure = ((pressure - 950) / 100).clamp(0.0, 1.0);
    
    // Dessiner l'arc de progression
    final progressPaint = Paint()
      ..color = theme.colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5 * normalizedPressure * progress,
      false,
      progressPaint,
    );

    // Liste des conditions météo avec leurs icônes et plages de pression
    final weatherConditions = [
      WeatherCondition('🌪️', 950, 'Tempête', theme.colorScheme.error),
      WeatherCondition('🌧️', 970, 'Pluie', theme.colorScheme.error),
      WeatherCondition('☔', 990, 'Averses', theme.colorScheme.primary),
      WeatherCondition('⛅', 1010, 'Variable', theme.colorScheme.primary),
      WeatherCondition('☀️', 1030, 'Ensoleillé', theme.colorScheme.tertiary),
      WeatherCondition('🌞', 1050, 'Très sec', theme.colorScheme.tertiary),
    ];

    // Dessiner les graduations et les icônes météo
    final markerPaint = Paint()
      ..color = theme.colorScheme.onSurfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i <= 10; i++) {
      final angle = math.pi * 0.75 + (math.pi * 1.5 * i / 10);
      final outerPoint = Offset(
        center.dx + (radius + 15) * math.cos(angle),
        center.dy + (radius + 15) * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 15) * math.cos(angle),
        center.dy + (radius - 15) * math.sin(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, markerPaint);

      // Calculer l'angle normalisé (0 à 1)
      final normalizedAngle = (angle - math.pi * 0.75) / (math.pi * 1.5);
      
      // Ajouter les valeurs de pression
      final currentPressure = 950 + (i * 10);
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$currentPressure',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textPoint = Offset(
        center.dx + (radius + 35) * math.cos(angle) - textPainter.width / 2,
        center.dy + (radius + 35) * math.sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, textPoint);

      // Ajouter les icônes météo
      if (i % 2 == 0) {
        final weatherIndex = i ~/ 2;
        if (weatherIndex < weatherConditions.length) {
          final condition = weatherConditions[weatherIndex];
          final iconPainter = TextPainter(
            text: TextSpan(
              text: condition.icon,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          iconPainter.layout();

          // Position de l'icône encore plus proche
          final iconRadius = radius + 60;
          final iconPoint = Offset(
            center.dx + iconRadius * math.cos(angle) - iconPainter.width / 2,
            center.dy + iconRadius * math.sin(angle) - iconPainter.height / 2,
          );
          iconPainter.paint(canvas, iconPoint);

          // Dessiner le texte descriptif
          final descriptionPainter = TextPainter(
            text: TextSpan(
              text: condition.description,
              style: TextStyle(
                color: condition.color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          descriptionPainter.layout();

          // Calculer la position du texte en fonction de l'angle
          double textAngle = angle;
          double textRadius = iconRadius + 25;

          // Ajuster la position du texte selon le quadrant
          if (normalizedAngle <= 0.25) {
            // Texte à droite de l'icône (quadrant supérieur droit)
            textAngle = angle;
            textRadius = iconRadius + 25;
          } else if (normalizedAngle <= 0.5) {
            // Texte au-dessus de l'icône (quadrant supérieur gauche)
            textRadius = iconRadius + 20;
          } else if (normalizedAngle <= 0.75) {
            // Texte à gauche de l'icône (quadrant inférieur gauche)
            textAngle = angle;
            textRadius = iconRadius + 25;
          } else {
            // Texte en dessous de l'icône (quadrant inférieur droit)
            textRadius = iconRadius + 20;
          }

          final textPoint = Offset(
            center.dx + textRadius * math.cos(textAngle) - descriptionPainter.width / 2,
            center.dy + textRadius * math.sin(textAngle) - descriptionPainter.height / 2,
          );
          
          // Ajouter un fond semi-transparent pour améliorer la lisibilité
          final textBackground = Path()
            ..addRect(Rect.fromCenter(
              center: textPoint.translate(
                descriptionPainter.width / 2,
                descriptionPainter.height / 2,
              ),
              width: descriptionPainter.width + 4,
              height: descriptionPainter.height + 2,
            ));
          
          canvas.drawPath(
            textBackground,
            Paint()
              ..color = theme.colorScheme.surface.withOpacity(0.7)
              ..style = PaintingStyle.fill,
          );
          
          descriptionPainter.paint(canvas, textPoint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant BarometerPainter oldDelegate) {
    return oldDelegate.pressure != pressure || 
           oldDelegate.altitude != altitude ||
           oldDelegate.progress != progress ||
           oldDelegate.theme != theme;
  }
} 