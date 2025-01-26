// lib/data/repositories/tts_repository_impl.dart
import 'package:fluent_chat/data/service/tts_service.dart';
import 'package:fluent_chat/domain/repositories/tts_repository.dart';

class TtsRepositoryImpl implements TtsRepository {
  final TtsService _ttsService;

  TtsRepositoryImpl(this._ttsService);

  @override
  Future<void> initialize() async {
    await _ttsService.initialize();
  }

  @override
  Future<void> speak(String text) async {
    await _ttsService.speak(text);
  }

  @override
  Future<void> stop() async {
    await _ttsService.stop();
  }

  @override
  Future<bool> isSpeaking() async {
    return await _ttsService.isSpeaking();
  }
}
