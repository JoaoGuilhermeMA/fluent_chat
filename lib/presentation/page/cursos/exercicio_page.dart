import 'package:fluent_chat/domain/entities/partida.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:fluent_chat/presentation/page/cursos/escuta_page.dart';
import 'package:fluent_chat/presentation/page/cursos/fala_page.dart';
import 'package:fluent_chat/presentation/page/cursos/vocabulario_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PraticarPage extends StatefulWidget {
  @override
  _PraticarPageState createState() => _PraticarPageState();
}

class _PraticarPageState extends State<PraticarPage> {
  late Partida _partida;
  int _indiceExercicioAtual = 0;
  late List<Widget> _exercicios; // Declare a lista como late

  @override
  void initState() {
    super.initState();
    _partida = Partida(vidas: 5, respostasCorretas: 0);

    // Inicialize a lista de exercícios dentro do initState
    _exercicios = [
      VocabularioPage(onRespostaVerificada: (bool respostaCorreta) {
        _proximoExercicio(respostaCorreta);
      }),
      EscutaPage(onRespostaVerificada: (bool respostaCorreta) {
        _proximoExercicio(respostaCorreta);
      }),
      FalaPage(onRespostaVerificada: (bool respostaCorreta) {
        _proximoExercicio(respostaCorreta);
      }),
    ];
  }

  void _proximoExercicio(bool respostaCorreta) {
    setState(() {
      if (!respostaCorreta) {
        _partida.vidas--; // Perde uma vida se errar
        if (_partida.vidas <= 0) {
          _finalizarPartida(); // Finaliza a partida se não houver mais vidas
        }
      } else {
        _partida.respostasCorretas++; // Incrementa respostas corretas
        if (_indiceExercicioAtual < _exercicios.length - 1) {
          _indiceExercicioAtual++; // Avança para o próximo exercício
        } else {
          _finalizarPartida(); // Finaliza a partida se todos os exercícios forem completados
        }
      }
    });
  }

  void _finalizarPartida() async {
    final usuarioRepository =
        Provider.of<UsuarioRepository>(context, listen: false);
    final userId = Provider.of<AuthRepository>(context, listen: false)
        .getCurrentUserEmail()!;

    await usuarioRepository.atualizarProgresso(
      userId: userId,
      livesUsed: 5 - _partida.vidas,
      correctAnswers: _partida.respostasCorretas,
    );

    Navigator.pop(context); // Volta para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Praticar'),
        actions: [
          Row(
            children: List.generate(
              _partida.vidas,
              (index) => Icon(Icons.favorite, color: Colors.red),
            ),
          ),
        ],
      ),
      body: _exercicios[_indiceExercicioAtual],
    );
  }
}
