import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_chat/data/service/chats_publicos_services.dart';
import 'package:fluent_chat/domain/repositories/chats_publicos_repository.dart';

class ChatsPublicosImpl extends ChatsPublicosRepository {
  final ChatPublicoService _chatPublicoService;

  ChatsPublicosImpl(this._chatPublicoService);

  @override
  Future<void> adicionarMensagem(
      String chatNome, String email, String texto) async {
    _chatPublicoService.adicionarMensagem(chatNome, email, texto);
  }

  @override
  Future<DocumentSnapshot<Object?>?> buscarComunidade(String chatNome) {
    return _chatPublicoService.buscarComunidade(chatNome);
  }

  @override
  Future<List<QueryDocumentSnapshot<Object?>>> buscarTodasAsComunidades() {
    return _chatPublicoService.buscarTodasAsComunidades();
  }

  @override
  Future<void> criarComunidade(String chatNome, String descricao,
      String adminEmail, String imagemUrl) async {
    _chatPublicoService.criarComunidade(
        chatNome, descricao, adminEmail, imagemUrl);
  }

  @override
  Future<void> editarComunidade(
      String chatNome, Map<String, dynamic> dadosAtualizados) async {
    _chatPublicoService.editarComunidade(chatNome, dadosAtualizados);
  }

  @override
  Future<void> excluirComunidade(String chatNome) async {
    _chatPublicoService.excluirComunidade(chatNome);
  }

  @override
  Future<List<Map<String, dynamic>>> buscarComunidadesPaginadas({
    required int pageSize,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      final query = _chatPublicoService.chatPublicoCollection
          .orderBy('descricao')
          .limit(pageSize);

      final querySnapshot = lastDocument == null
          ? await query.get()
          : await query.startAfterDocument(lastDocument).get();

      // Inclui o ID do documento nos dados retornados
      final newItems = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Adiciona o ID do documento
          ...doc.data()
              as Map<String, dynamic>, // Adiciona os dados do documento
        };
      }).toList();

      return newItems;
    } catch (error) {
      print('Erro ao buscar comunidades paginadas: $error');
      throw Exception('Erro ao buscar comunidades paginadas');
    }
  }

  @override
  Stream<QuerySnapshot> buscarMensagens(String chatNome) {
    return _chatPublicoService.buscarMensagens(chatNome);
  }
}
