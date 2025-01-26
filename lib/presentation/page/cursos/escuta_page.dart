// lib/presentation/pages/escuta_page.dart
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';
import 'package:fluent_chat/domain/repositories/tts_repository.dart';
import 'fala_page.dart'; // Importe a página de fala

class EscutaPage extends StatefulWidget {
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
      // Busca uma frase aleatória
      final textoRepository =
          Provider.of<TextoRepository>(context, listen: false);
      final frase = await textoRepository.buscarFraseAleatoria(
          _rankUser.toLowerCase()); // Use o rank do usuário

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

  Future<void> _reproduzirAudio() async {
    if (_fraseAtual != null) {
      final ttsRepository = Provider.of<TtsRepository>(context, listen: false);
      await ttsRepository.speak(_fraseAtual!);
    }
  }

  void _verificarResposta() {
    final respostaUsuario = _respostaController.text.trim();
    if (respostaUsuario.toLowerCase() == _fraseAtual?.toLowerCase()) {
      setState(() {
        _respostaCorreta = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta correta!')),
      );

      // Navega para a página de fala após 1 segundo
      Future.delayed(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FalaPage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resposta incorreta! Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercício de Escuta'),
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
              // Botão de play para reproduzir o áudio
              Center(
                child: IconButton(
                  icon: Icon(Icons.play_circle_filled, size: 64.0),
                  onPressed: _reproduzirAudio,
                ),
              ),
              SizedBox(height: 20.0),
              // Campo de texto para a resposta do usuário
              TextField(
                controller: _respostaController,
                decoration: InputDecoration(
                  labelText: 'Digite o que você ouviu',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              // Botão para verificar a resposta
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
