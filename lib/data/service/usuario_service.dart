import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_chat/domain/entities/perfil.dart';
import 'dart:io';
import 'firebase_storage_service.dart';

class UsuarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorageService _storageService = FirebaseStorageService();

  // Método para criar um novo usuário no Firestore
  Future<void> criarUsuario({
    required String userId,
    required String name,
    required String email,
    required File profilePicture,
    required String rank,
  }) async {
    try {
      // Caminho remoto no Firebase Storage para a foto do perfil
      String remotePath = 'profile_pictures/$userId.jpg';

      // Faz upload da foto do perfil
      await _storageService.uploadFile(profilePicture, remotePath);

      // Obtém a URL da foto do perfil
      String? profilePictureUrl =
          await _storageService.downloadFile(remotePath);
      if (profilePictureUrl == null) {
        throw Exception('Erro ao obter URL da foto do perfil');
      }

      // Cria uma instância de User
      Perfil perfil = Perfil(
        name: name,
        email: email,
        profilePicture: profilePictureUrl,
        rank: rank,
      );

      // Salva o usuário no Firestore
      await _firestore.collection('users').doc(userId).set(perfil.toMap());
      print('Usuário criado com sucesso.');
    } catch (e) {
      print('Erro ao criar usuário: $e');
    }
  }

  // Método para buscar um usuário no Firestore pelo userId
  Future<Perfil?> buscarUsuario(String userId) async {
    print("userId: " + userId);
    try {
      // Obtém o documento do usuário no Firestore
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        // Converte o documento para um objeto User usando o fromMap
        return Perfil.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Usuário não encontrado');
        print("estou aqui");
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
      return null;
    }
  }
}
