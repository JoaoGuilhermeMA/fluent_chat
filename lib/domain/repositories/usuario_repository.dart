import 'dart:io';

import 'package:fluent_chat/domain/entities/perfil.dart';

abstract class UsuarioRepository {
  Future<void> criarUsuario({
    required String userId,
    required String name,
    required String email,
    required File profilePicture,
    required String rank,
  });
  // Método para buscar um usuário no Firestore pelo userId
  Future<Perfil?> buscarUsuario(String userId);

  Future<void> atualizarProgresso({
    required String userId,
    required int livesUsed,
    required int correctAnswers,
  });

  Future<void> salvarHistoricoPartida({
    required String userId,
    required String rankAtual,
    required String fraseVocabulario,
    required String fraseEscuta,
    required String fraseFala,
    required int pontosGanhos,
    required int pontosPerdidos,
    required bool ganhou,
  });

  // Método para obter o próximo número de partida
  Future<int> _obterProximoNumeroPartida(String userId);

  // Método para buscar o histórico de partidas do usuário
  Future<List<Map<String, dynamic>>> buscarHistorico(String userId);

  // Método para calcular o rank com base nos pontos
  String _calculateRank(int points);
}
