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

  // Variáveis para armazenar as frases de cada exercício
  String _fraseVocabulario = '';
  String _fraseEscuta = '';
  String _fraseFala = '';

  @override
  void initState() {
    super.initState();
    _partida = Partida(
      vidas: 5,
      respostasCorretas: 0,
      timestamp: DateTime.now(), // Inicializa o timestamp
      rankAtual: '', // Será atualizado ao carregar o perfil do usuário
      fraseVocabulario: '', // Será atualizado durante a partida
      fraseEscuta: '', // Será atualizado durante a partida
      fraseFala: '', // Será atualizado durante a partida
      pontosGanhos: 0, // Será calculado ao final da partida
      pontosPerdidos: 0, // Será calculado ao final da partida
      ganhou: false, // Será definido ao final da partida
    );

    // Inicialize a lista de exercícios dentro do initState
    _exercicios = [
      VocabularioPage(
        onRespostaVerificada: (bool respostaCorreta) {
          _proximoExercicio(respostaCorreta);
        },
        onFraseCarregada: (String frase) {
          setState(() {
            _fraseVocabulario = frase;
          });
        },
      ),
      EscutaPage(
        onRespostaVerificada: (bool respostaCorreta) {
          _proximoExercicio(respostaCorreta);
        },
        onFraseCarregada: (String frase) {
          setState(() {
            _fraseEscuta = frase;
          });
        },
      ),
      FalaPage(
        onRespostaVerificada: (bool respostaCorreta) {
          _proximoExercicio(respostaCorreta);
        },
        onFraseCarregada: (String frase) {
          setState(() {
            _fraseFala = frase;
          });
        },
      ),
    ];

    // Carrega o rank do usuário ao iniciar a partida
    _carregarRankDoUsuario();
  }

  Future<void> _carregarRankDoUsuario() async {
    final usuarioRepository =
        Provider.of<UsuarioRepository>(context, listen: false);
    final userId = Provider.of<AuthRepository>(context, listen: false)
        .getCurrentUserEmail()!;
    final perfil = await usuarioRepository.buscarUsuario(userId);

    if (perfil != null) {
      setState(() {
        _partida.rankAtual = perfil.rank;
      });
    }
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

    // Calcula os pontos ganhos e perdidos
    const int pontosPorRespostaCorreta = 10;
    const int penalidadePorVidaPerdida = 5;

    int pontosGanhos = _partida.respostasCorretas * pontosPorRespostaCorreta;
    int pontosPerdidos = (5 - _partida.vidas) * penalidadePorVidaPerdida;

    // Define se o usuário ganhou a partida
    bool ganhou = _partida.vidas > 0;

    // Atualiza os dados da partida
    _partida = _partida.copyWith(
      fraseVocabulario: _fraseVocabulario,
      fraseEscuta: _fraseEscuta,
      fraseFala: _fraseFala,
      pontosGanhos: pontosGanhos,
      pontosPerdidos: pontosPerdidos,
      ganhou: ganhou,
    );

    // Salva a partida no Firebase usando o método salvarHistoricoPartida
    await usuarioRepository.salvarHistoricoPartida(
      userId: userId,
      rankAtual: _partida.rankAtual,
      fraseVocabulario: _partida.fraseVocabulario,
      fraseEscuta: _partida.fraseEscuta,
      fraseFala: _partida.fraseFala,
      pontosGanhos: _partida.pontosGanhos,
      pontosPerdidos: _partida.pontosPerdidos,
      ganhou: _partida.ganhou,
    );

    // Atualiza o progresso do usuário
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
