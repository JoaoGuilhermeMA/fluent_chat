import 'dart:io';

import 'package:fluent_chat/data/service/usuario_service.dart';
import 'package:fluent_chat/domain/entities/perfil.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';

class UsuarioRepositoryImpl extends UsuarioRepository {
  final UsuarioService _usuarioService;

  UsuarioRepositoryImpl(this._usuarioService);

  @override
  Future<Perfil?> buscarUsuario(String userId) {
    return _usuarioService.buscarUsuario(userId);
  }

  @override
  Future<void> criarUsuario({
    required String userId,
    required String name,
    required String email,
    required File profilePicture,
    required String rank,
  }) async {
    await _usuarioService.criarUsuario(
      userId: userId,
      name: name,
      email: email,
      profilePicture: profilePicture,
      rank: rank,
    );
  }

  @override
  Future<void> atualizarProgresso({
    required String userId,
    required int livesUsed,
    required int correctAnswers,
  }) async {
    await _usuarioService.atualizarProgresso(
      userId: userId,
      livesUsed: livesUsed,
      correctAnswers: correctAnswers,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> buscarHistorico(String userId) {
    return _usuarioService.buscarHistorico(userId);
  }

  @override
  Future<void> salvarHistoricoPartida(
      {required String userId,
      required String rankAtual,
      required String fraseVocabulario,
      required String fraseEscuta,
      required String fraseFala,
      required int pontosGanhos,
      required int pontosPerdidos,
      required bool ganhou}) async {
    _usuarioService.salvarHistoricoPartida(
        userId: userId,
        rankAtual: rankAtual,
        fraseVocabulario: fraseVocabulario,
        fraseEscuta: fraseEscuta,
        fraseFala: fraseFala,
        pontosGanhos: pontosGanhos,
        pontosPerdidos: pontosPerdidos,
        ganhou: ganhou);
  }
}
