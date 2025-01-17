import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'ui/screens/barometer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baromètre',
      theme: AppTheme.lightTheme,
      home: const BarometerScreen(title: 'Baromètre'),
    );
  }
}
