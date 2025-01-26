// lib/presentation/pages/exercise_page.dart
import 'package:fluent_chat/data/service/tts_service.dart';
import 'package:fluent_chat/domain/repositories/tts_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatelessWidget {
  final String phrase;

  ExercisePage({required this.phrase});

  @override
  Widget build(BuildContext context) {
    final ttsRepository = context.read<TtsRepository>();

    return Scaffold(
      appBar: AppBar(title: Text('Exercício')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(phrase),
            ElevatedButton(
              onPressed: () async {
                await ttsRepository.speak(phrase); // Reproduz a frase
              },
              child: Text('Ouvir Frase'),
            ),
          ],
        ),
      ),
    );
  }
}
