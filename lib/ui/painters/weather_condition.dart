import 'package:flutter/material.dart';

class WeatherCondition {
  final String icon;
  final int pressure;
  final String description;
  final Color color;

  WeatherCondition(this.icon, this.pressure, this.description, this.color);
} 