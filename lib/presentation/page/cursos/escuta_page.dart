import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';
import 'package:fluent_chat/domain/repositories/tts_repository.dart';

class EscutaPage extends StatefulWidget {
  final Function(bool) onRespostaVerificada;
  final Function(String) onFraseCarregada;

  EscutaPage({
    required this.onRespostaVerificada,
    required this.onFraseCarregada,
  });

  @override
  _EscutaPageState createState() => _EscutaPageState();
}

class _EscutaPageState extends State<EscutaPage> {
  final TextEditingController _respostaController = TextEditingController();
  String? _fraseAtual;
  bool _respostaCorreta = false;
  bool _carregando = false;
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

    final usuarioRepository =
        Provider.of<UsuarioRepository>(context, listen: false);
    idUser = Provider.of<AuthRepository>(context, listen: false)
        .getCurrentUserEmail()!;
    final perfil = await usuarioRepository.buscarUsuario(idUser);

    try {
      if (perfil != null) {
        _rankUser = perfil.rank;
      }
      final textoRepository =
          Provider.of<TextoRepository>(context, listen: false);
      final frase =
          await textoRepository.buscarFraseAleatoria(_rankUser.toLowerCase());

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

  Future<void> _reproduzirAudio() async {
    if (_fraseAtual != null) {
      final ttsRepository = Provider.of<TtsRepository>(context, listen: false);
      await ttsRepository.speak(_fraseAtual!);
    }
  }

  void _verificarResposta() {
    final respostaUsuario = _respostaController.text.trim();
    bool respostaCorreta =
        respostaUsuario.toLowerCase() == _fraseAtual?.toLowerCase();

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
          'Exercício de Escuta',
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
                      IconButton(
                        icon: Icon(
                          Icons.play_circle_filled,
                          size: 64.0,
                          color: colorScheme.primary,
                        ),
                        onPressed: _reproduzirAudio,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Clique no ícone para ouvir a frase',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _respostaController,
                decoration: InputDecoration(
                  labelText: 'Digite o que você ouviu',
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                style: TextStyle(color: colorScheme.onSurface),
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
