import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false; // Estado manual para controlar se está falando

  // Inicializa o TTS
  Future<void> initialize() async {
    await _flutterTts
        .setLanguage('en-US'); // Define o idioma (inglês americano)
    await _flutterTts.setSpeechRate(0.5); // Define a velocidade da fala
    await _flutterTts.setVolume(1.0); // Define o volume
    await _flutterTts.setPitch(1.0); // Define o tom

    // Define o handler quando a fala começa
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });

    // Define o handler quando a fala termina
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    // Define o handler quando a fala é interrompida
    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
    });
  }

  // Reproduz uma frase
  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  // Para a reprodução
  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false; // Atualiza o estado manualmente
  }

  // Verifica se o TTS está falando
  bool isSpeaking() {
    return _isSpeaking;
  }
}
