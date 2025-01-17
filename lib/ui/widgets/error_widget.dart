import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String error;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: error)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message d\'erreur copié dans le presse-papiers'),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copier l\'erreur'),
          ),
        ],
      ),
    );
  }
} 