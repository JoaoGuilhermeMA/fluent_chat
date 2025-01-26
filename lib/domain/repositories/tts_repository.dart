// lib/domain/repositories/tts_repository.dart
abstract class TtsRepository {
  Future<void> initialize();
  Future<void> speak(String text);
  Future<void> stop();
  Future<bool> isSpeaking();
}
