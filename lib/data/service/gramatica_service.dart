import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/models/topico_model.dart';

class GramaticaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Busca todos os tópicos de um rank específico
  Future<List<TopicoModel>> getTopicosByRank(String rank) async {
    try {
      // Acessa a coleção "gramatica", o documento do rank e a subcoleção "topicos"
      final querySnapshot = await _firestore
          .collection('gramatica')
          .doc(rank)
          .collection('topicos')
          .get();

      // Converte os documentos em uma lista de TopicoModel
      return querySnapshot.docs
          .map((doc) => TopicoModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint("Erro ao buscar tópicos: $e");
      throw Exception("Erro ao buscar tópicos");
    }
  }

  // Busca todos os ranks disponíveis
  Future<List<String>> getRanks() async {
    try {
      final querySnapshot = await _firestore.collection('gramatica').get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      debugPrint("Erro ao buscar ranks: $e");
      throw Exception("Erro ao buscar ranks");
    }
  }
}
