import 'dart:io';

import 'package:fluent_chat/data/service/usuario_service.dart';
import 'package:fluent_chat/domain/entities/perfil.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';

class UsuarioRepositoryImpl extends UsuarioRepository {
  final UsuarioService _usuarioService;

  UsuarioRepositoryImpl(this._usuarioService);

  Future<Perfil?> buscarUsuario(String userId) {
    return _usuarioService.buscarUsuario(userId);
  }

  @override
  Future<void> criarUsuario(
      {required String userId,
      required String name,
      required String email,
      required File profilePicture,
      required String rank}) async {
    _usuarioService.criarUsuario(
        userId: userId,
        name: name,
        email: email,
        profilePicture: profilePicture,
        rank: rank);
  }
}
