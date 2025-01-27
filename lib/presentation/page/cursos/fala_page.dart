import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';
import 'package:fluent_chat/domain/repositories/speech_repository.dart';

class FalaPage extends StatefulWidget {
  final Function(bool) onRespostaVerificada;

  FalaPage({required this.onRespostaVerificada});

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
    // Remove o ponto final da frase original (se houver)
    String fraseSemPonto = _fraseAtual?.replaceAll(RegExp(r'\.$'), '') ?? '';

    // Compara o texto reconhecido com a frase sem o ponto final
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

    // Chama a função onRespostaVerificada passando o resultado da resposta
    widget.onRespostaVerificada(respostaCorreta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercício de Fala'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_carregando)
              Center(child: CircularProgressIndicator())
            else if (_fraseAtual != null) ...[
              Text(
                'Fale a frase:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                _fraseAtual!,
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Center(
                child: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    size: 64.0,
                  ),
                  onPressed: _iniciarReconhecimento,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Você disse:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                _textoReconhecido,
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _verificarResposta,
                child: Text('Verificar Resposta'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
