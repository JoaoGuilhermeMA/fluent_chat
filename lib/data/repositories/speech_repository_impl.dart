// lib/data/repositories/speech_repository_impl.dart
import 'package:fluent_chat/data/service/speech_service.dart';

import '../../domain/repositories/speech_repository.dart';

class SpeechRepositoryImpl implements SpeechRepository {
  final SpeechService _speechService;

  SpeechRepositoryImpl(this._speechService);

  @override
  bool get isListening => _speechService.isListening;

  @override
  String get text => _speechService.text;

  @override
  double get confidence => _speechService.confidence;

  @override
  Future<void> initialize() async {
    await _speechService.initialize();
  }

  @override
  Future<void> listen({
    required Function(String) onResult,
    required Function(bool) onListeningStatusChanged,
  }) async {
    await _speechService.listen(
      onResult: onResult,
      onListeningStatusChanged: onListeningStatusChanged,
    );
  }
}
