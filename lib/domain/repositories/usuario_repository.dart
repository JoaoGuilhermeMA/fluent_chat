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
}
