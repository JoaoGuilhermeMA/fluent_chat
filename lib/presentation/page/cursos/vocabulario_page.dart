// lib/presentation/pages/vocabulario_page.dart
import 'package:fluent_chat/core/utils/translation_helper.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularioPage extends StatefulWidget {
  @override
  _VocabularioPageState createState() => _VocabularioPageState();
}

class _VocabularioPageState extends State<VocabularioPage> {
  final TextEditingController _respostaController = TextEditingController();
  String? _fraseAtual;
  String? _traducaoCorreta;
  bool _respostaCorreta = false;
  String _rankUser =
      "bronze"; // Rank padrão, caso não seja possível buscar o rank do usuário
  bool _carregando = false;
  late String idUser;

  @override
  void initState() {
    super.initState();
    _carregarDadosDoUsuarioEFrase();
  }

  Future<void> _carregarDadosDoUsuarioEFrase() async {
    setState(() {
      _carregando = true;
    });

    try {
      // Busca o perfil do usuário
      final usuarioRepository =
          Provider.of<UsuarioRepository>(context, listen: false);
      idUser = Provider.of<AuthRepository>(context, listen: false)
          .getCurrentUserEmail()!;
      final perfil = await usuarioRepository.buscarUsuario(idUser);

      if (perfil != null) {
        setState(() {
          _rankUser = perfil.rank;
        });

        final textoRepository =
            Provider.of<TextoRepository>(context, listen: false);
        final frase =
            await textoRepository.buscarFraseAleatoria(_rankUser.toLowerCase());

        final traducao = await TranslationHelper.translateText(frase);

        setState(() {
          _fraseAtual = frase;
          _traducaoCorreta = traducao;
          _respostaCorreta = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário não encontrado')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _verificarResposta() {
    final respostaUsuario = _respostaController.text.trim();
    if (respostaUsuario.toLowerCase() == _traducaoCorreta?.toLowerCase()) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercício de Vocabulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_carregando)
              Center(child: CircularProgressIndicator())
            else if (_fraseAtual != null) ...[
              Text(
                'Traduza a frase:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                _fraseAtual!,
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _respostaController,
                decoration: InputDecoration(
                  labelText: 'Sua tradução',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _verificarResposta,
                child: Text('Verificar Resposta'),
              ),
              if (_respostaCorreta)
                ElevatedButton(
                  onPressed: _carregarDadosDoUsuarioEFrase,
                  child: Text('Próxima Frase'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
