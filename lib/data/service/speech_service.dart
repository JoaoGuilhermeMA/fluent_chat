// lib/data/services/speech_service.dart
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "Pressione o botão para falar";
  double _confidence = 1.0;

  bool get isListening => _isListening;
  String get text => _text;
  double get confidence => _confidence;

  Future<void> initialize() async {
    await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
  }

  Future<void> listen({
    required Function(String) onResult,
    required Function(bool) onListeningStatusChanged,
  }) async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        _isListening = true;
        onListeningStatusChanged(_isListening);

        _speech.listen(
          onResult: (val) {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            onResult(_text);
          },
        );
      }
    } else {
      _isListening = false;
      onListeningStatusChanged(_isListening);
      _speech.stop();
    }
  }
}
