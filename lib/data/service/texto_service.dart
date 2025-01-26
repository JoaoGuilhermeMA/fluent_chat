import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class TextoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> buscarFraseAleatoria(String rank) async {
    try {
      // Referência para a subcoleção "frases" dentro do documento do rank
      CollectionReference frasesRef =
          _firestore.collection('frases').doc(rank).collection('frases');

      // Busca todos os documentos da subcoleção "frases"
      QuerySnapshot querySnapshot = await frasesRef.get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Nenhuma frase encontrada para o rank $rank');
      }

      // Seleciona um documento aleatório
      Random random = Random();
      int randomIndex = random.nextInt(querySnapshot.docs.length);
      DocumentSnapshot randomDoc = querySnapshot.docs[randomIndex];

      // Retorna o campo "texto" do documento selecionado
      return randomDoc['texto'];
    } catch (e) {
      throw Exception('Erro ao buscar frase: $e');
    }
  }
}
