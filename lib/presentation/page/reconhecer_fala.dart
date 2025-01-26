// lib/presentation/pages/speech_page.dart
import 'package:fluent_chat/data/service/speech_service.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/speech_repository_impl.dart';
import '../widgets/speech_ui.dart';

class SpeechToTextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final speechService = SpeechService();
    final speechRepository = SpeechRepositoryImpl(speechService);

    return Scaffold(
      body: SpeechUI(speechRepository: speechRepository),
    );
  }
}
