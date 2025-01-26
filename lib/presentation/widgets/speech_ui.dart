// lib/presentation/widgets/speech_ui.dart
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import '../../domain/repositories/speech_repository.dart';

class SpeechUI extends StatefulWidget {
  final SpeechRepository speechRepository;

  const SpeechUI({required this.speechRepository});

  @override
  _SpeechUIState createState() => _SpeechUIState();
}

class _SpeechUIState extends State<SpeechUI> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Confidence: ${(widget.speechRepository.confidence * 100.0).toStringAsFixed(1)}'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: widget.speechRepository.isListening,
        glowColor: Theme.of(context).primaryColor,
        glowRadiusFactor: 2.0,
        duration: const Duration(milliseconds: 2000),
        startDelay: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(
              widget.speechRepository.isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: widget.speechRepository.text,
            words: _highlights,
            textStyle: const TextStyle(
                fontSize: 32.0,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    await widget.speechRepository.listen(
      onResult: (text) {
        setState(() {});
      },
      onListeningStatusChanged: (isListening) {
        setState(() {});
      },
    );
  }
}
