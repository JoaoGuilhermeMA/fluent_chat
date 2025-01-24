import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatsPublicosRepository {
  Future<void> criarComunidade(
      String chatNome, String descricao, String adminEmail, String imagemUrl);
  Future<void> editarComunidade(
      String chatNome, Map<String, dynamic> dadosAtualizados);
  Future<List<QueryDocumentSnapshot>> buscarTodasAsComunidades();
  Future<DocumentSnapshot?> buscarComunidade(String chatNome);
  Future<void> excluirComunidade(String chatNome);
  Future<void> adicionarMensagem(String chatNome, String email, String texto);
}
