import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPublicoService {
  final CollectionReference chatPublicoCollection =
      FirebaseFirestore.instance.collection('chatPublico');

  Future<void> criarComunidade(String chatNome, String descricao,
      String adminEmail, String imagemUrl) async {
    try {
      await chatPublicoCollection.doc(chatNome).set({
        'descricao': descricao,
        'usuarios': [adminEmail],
        'adminEmail': adminEmail,
        'imagemUrl': imagemUrl,
      });
    } catch (e) {
      print('Erro ao criar comunidade: $e');
    }
  }

  Future<void> editarComunidade(
      String chatNome, Map<String, dynamic> dadosAtualizados) async {
    try {
      await chatPublicoCollection.doc(chatNome).update(dadosAtualizados);
    } catch (e) {
      print('Erro ao editar comunidade: $e');
    }
  }

  // Buscar todas as comunidades
  Future<List<QueryDocumentSnapshot>> buscarTodasAsComunidades() async {
    try {
      QuerySnapshot snapshot = await chatPublicoCollection.get();
      return snapshot.docs;
    } catch (e) {
      print('Erro ao buscar comunidades: $e');
      return [];
    }
  }

  // Buscar uma comunidade específica
  Future<DocumentSnapshot?> buscarComunidade(String chatNome) async {
    try {
      DocumentSnapshot doc = await chatPublicoCollection.doc(chatNome).get();
      return doc.exists ? doc : null;
    } catch (e) {
      print('Erro ao buscar comunidade: $e');
      return null;
    }
  }

  // Excluir uma comunidade
  Future<void> excluirComunidade(String chatNome) async {
    try {
      await chatPublicoCollection.doc(chatNome).delete();
    } catch (e) {
      print('Erro ao excluir comunidade: $e');
    }
  }

  // Adicionar mensagem à subcoleção 'mensagens'
  Future<void> adicionarMensagem(
      String chatNome, String email, String texto) async {
    String idMensagem = '$email-${DateTime.now().millisecondsSinceEpoch}';
    try {
      await chatPublicoCollection
          .doc(chatNome)
          .collection('mensagens')
          .doc(idMensagem)
          .set({
        'enviadoPor': email,
        'texto': texto,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Erro ao adicionar mensagem: $e');
    }
  }

  Stream<QuerySnapshot> buscarMensagens(String chatNome) {
    print('Buscando mensagens de $chatNome: ');

    // Obtém o stream de mensagens
    final stream = chatPublicoCollection
        .doc(chatNome)
        .collection('mensagens')
        .orderBy('timestamp', descending: false)
        .snapshots();

    // Adiciona um listener para depuração
    stream.listen((QuerySnapshot snapshot) {
      print('Nova atualização no stream: ${snapshot.docs.length} mensagens');
      for (var doc in snapshot.docs) {
        print('Mensagem: ${doc.data()}');
      }
    }, onError: (error) {
      print('Erro no stream: $error');
    });

    return stream;
  }
}
