import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';
import 'package:fluent_chat/domain/repositories/speech_repository.dart';

class FalaPage extends StatefulWidget {
  final Function(bool) onRespostaVerificada;
  final Function(String) onFraseCarregada;

  FalaPage({
    required this.onRespostaVerificada,
    required this.onFraseCarregada,
  });

  @override
  _FalaPageState createState() => _FalaPageState();
}

class _FalaPageState extends State<FalaPage> {
  final TextEditingController _respostaController = TextEditingController();
  String? _fraseAtual;
  bool _respostaCorreta = false;
  bool _carregando = false;
  bool _isListening = false;
  String _textoReconhecido = "Pressione o botão para falar";
  late String idUser;
  late String _rankUser;

  @override
  void initState() {
    super.initState();
    _carregarFraseAleatoria();
  }

  Future<void> _carregarFraseAleatoria() async {
    setState(() {
      _carregando = true;
    });

    try {
      final usuarioRepository =
          Provider.of<UsuarioRepository>(context, listen: false);
      idUser = Provider.of<AuthRepository>(context, listen: false)
          .getCurrentUserEmail()!;
      final perfil = await usuarioRepository.buscarUsuario(idUser);

      if (perfil != null) {
        _rankUser = perfil.rank;
      }

      final textoRepository =
          Provider.of<TextoRepository>(context, listen: false);
      final frase = await textoRepository.buscarFraseAleatoria("bronze");

      setState(() {
        _fraseAtual = frase;
      });

      widget.onFraseCarregada(frase);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar a frase: $e')),
      );
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _iniciarReconhecimento() async {
    final speechRepository =
        Provider.of<SpeechRepository>(context, listen: false);

    await speechRepository.listen(
      onResult: (texto) {
        setState(() {
          _textoReconhecido = texto;
        });
      },
      onListeningStatusChanged: (isListening) {
        setState(() {
          _isListening = isListening;
        });
      },
    );
  }

  void _verificarResposta() {
    String fraseSemPonto = _fraseAtual?.replaceAll(RegExp(r'\.$'), '') ?? '';
    bool respostaCorreta =
        _textoReconhecido.toLowerCase() == fraseSemPonto.toLowerCase();

    if (respostaCorreta) {
      setState(() {
        _respostaCorreta = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta correta!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta incorreta! Tente novamente.')),
      );
    }

    widget.onRespostaVerificada(respostaCorreta);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercício de Fala',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_carregando)
              Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              )
            else if (_fraseAtual != null) ...[
              Card(
                elevation: 4.0,
                color: colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Fale a frase:',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _fraseAtual!,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 64.0,
                    color: colorScheme.primary,
                  ),
                  onPressed: _iniciarReconhecimento,
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                elevation: 4.0,
                color: colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Você disse:',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _textoReconhecido,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _verificarResposta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Verificar Resposta',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
