import 'package:fluent_chat/core/utils/translation_helper.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularioPage extends StatefulWidget {
  final Function(bool) onRespostaVerificada;
  final Function(String) onFraseCarregada;

  VocabularioPage({
    required this.onRespostaVerificada,
    required this.onFraseCarregada,
  });

  @override
  _VocabularioPageState createState() => _VocabularioPageState();
}

class _VocabularioPageState extends State<VocabularioPage> {
  final TextEditingController _respostaController = TextEditingController();
  String? _fraseAtual;
  String _rankUser = "bronze";
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

        setState(() {
          _fraseAtual = frase;
        });

        widget.onFraseCarregada(frase);
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

  Future<void> _verificarResposta() async {
    final respostaUsuario = _respostaController.text.trim();
    final fraseTraduzida = await TranslationHelper.translateText(_fraseAtual!);
    bool respostaCorreta =
        respostaUsuario.toLowerCase() == fraseTraduzida.toLowerCase();

    if (respostaCorreta) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Traduza a frase:',
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _respostaController,
                decoration: InputDecoration(
                  labelText: 'Sua tradução',
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
