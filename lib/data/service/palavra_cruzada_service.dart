import 'package:cloud_firestore/cloud_firestore.dart';

class PalavraCruzadaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para buscar 5 palavras aleatórias por rank
  Future<List<Map<String, String>>> buscarPalavrasAleatorias(
      String rank) async {
    try {
      // Referência para a subcoleção de palavras do rank especificado
      final palavrasRef =
          _firestore.collection('palavra').doc(rank).collection('palavras');

      // Busca todas as palavras do rank
      final querySnapshot = await palavrasRef.get();

      // Converte os documentos em uma lista de mapas no formato desejado
      final todasPalavras = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'answer': data['answer'] as String,
          'description': data['description'] as String,
        };
      }).toList();

      // Embaralha a lista para obter palavras aleatórias
      todasPalavras.shuffle();

      // Retorna as 5 primeiras palavras da lista embaralhada
      return todasPalavras.take(5).toList();
    } catch (e) {
      print("Erro ao buscar palavras: $e");
      return [];
    }
  }
}
