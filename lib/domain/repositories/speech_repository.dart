// lib/domain/repositories/speech_repository.dart
abstract class SpeechRepository {
  Future<void> initialize();
  Future<void> listen({
    required Function(String) onResult,
    required Function(bool) onListeningStatusChanged,
  });

  bool get isListening;
  String get text;
  double get confidence;
}
