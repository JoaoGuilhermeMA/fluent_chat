import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_chat/data/service/firebase_storage_service.dart';
import 'package:fluent_chat/domain/entities/perfil.dart';

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

      // Cria uma instância de Perfil
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
        // Converte o documento para um objeto Perfil usando o fromMap
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

  // Método para atualizar o progresso do usuário
  Future<void> atualizarProgresso({
    required String userId,
    required int livesUsed,
    required int correctAnswers,
  }) async {
    try {
      // Busca o perfil do usuário
      Perfil? perfil = await buscarUsuario(userId);
      if (perfil == null) {
        throw Exception('Usuário não encontrado');
      }

      // Constantes para cálculo de pontos
      const int pointsPerCorrectAnswer = 10; // Pontos por resposta correta
      const int penaltyPerLifeLost = 5; // Penalidade por vida perdida

      // Calcula os pontos ganhos com base nas respostas corretas
      int pointsEarned = correctAnswers * pointsPerCorrectAnswer;

      // Calcula os pontos perdidos com base nas vidas perdidas
      int pointsLost = livesUsed * penaltyPerLifeLost;

      // Calcula os novos pontos
      int newPoints = perfil.points + pointsEarned - pointsLost;

      // Garante que os pontos não sejam negativos
      if (newPoints < 0) {
        newPoints = 0;
      }

      // Atualiza o rank com base nos pontos
      String newRank = _calculateRank(newPoints);

      // Atualiza o perfil do usuário
      Perfil updatedPerfil = perfil.copyWith(
        points: newPoints,
        rank: newRank,
      );

      // Salva o perfil atualizado no Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .set(updatedPerfil.toMap());
      print('Progresso do usuário atualizado com sucesso.');
    } catch (e) {
      print('Erro ao atualizar progresso do usuário: $e');
    }
  }

  // Método para salvar o histórico de partidas
  Future<void> salvarHistoricoPartida({
    required String userId,
    required String rankAtual,
    required String fraseVocabulario,
    required String fraseEscuta,
    required String fraseFala,
    required int pontosGanhos,
    required int pontosPerdidos,
    required bool ganhou,
  }) async {
    try {
      // Obtém o número da próxima partida
      int numeroPartida = await _obterProximoNumeroPartida(userId);

      // Cria o nome do documento da partida
      String nomeDocumento = 'partida$numeroPartida';

      // Cria um mapa com os dados da partida
      Map<String, dynamic> partidaData = {
        'timestamp': FieldValue.serverTimestamp(), // Timestamp do Firestore
        'rank': rankAtual,
        'fraseVocabulario': fraseVocabulario,
        'fraseEscuta': fraseEscuta,
        'fraseFala': fraseFala,
        'pontosGanhos': pontosGanhos,
        'pontosPerdidos': pontosPerdidos,
        'ganhou': ganhou,
      };

      // Salva a partida na subcoleção "historico"
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('historico')
          .doc(nomeDocumento)
          .set(partidaData);

      print('Histórico da partida salvo com sucesso.');
    } catch (e) {
      print('Erro ao salvar histórico da partida: $e');
    }
  }

  // Método para obter o próximo número de partida
  Future<int> _obterProximoNumeroPartida(String userId) async {
    try {
      // Obtém a subcoleção "historico" do usuário
      QuerySnapshot historicoSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('historico')
          .get();

      // O próximo número de partida é o número de documentos + 1
      return historicoSnapshot.size + 1;
    } catch (e) {
      print('Erro ao obter próximo número de partida: $e');
      return 1; // Se houver erro, começa com 1
    }
  }

  // Método para buscar o histórico de partidas do usuário
  Future<List<Map<String, dynamic>>> buscarHistorico(String userId) async {
    try {
      // Referência para a subcoleção 'historico' do usuário
      CollectionReference historicoRef =
          _firestore.collection('users').doc(userId).collection('historico');

      // Obtém todos os documentos da subcoleção
      QuerySnapshot historicoSnapshot = await historicoRef.get();

      // Converte os documentos para uma lista de mapas
      List<Map<String, dynamic>> historico = historicoSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return historico;
    } catch (e) {
      print('Erro ao buscar histórico: $e');
      return [];
    }
  }

  // Método para calcular o rank com base nos pontos
  String _calculateRank(int points) {
    if (points >= 800) return 'Radiante';
    if (points >= 600) return 'Diamante';
    if (points >= 400) return 'Ouro';
    if (points >= 200) return 'Prata';
    return 'Bronze';
  }
}
