import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/chats_publicos_repository.dart';
import 'chats/criar_chat.dart';
import 'chats/tela_chat.dart';

class ComunidadePage extends StatefulWidget {
  @override
  _ComunidadePageState createState() => _ComunidadePageState();
}

class _ComunidadePageState extends State<ComunidadePage> {
  static const _pageSize = 10;

  final PagingController<DocumentSnapshot?, Map<String, dynamic>>
      _pagingController = PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(DocumentSnapshot? lastDocument) async {
    try {
      final chatsPublicosRepository =
          Provider.of<ChatsPublicosRepository>(context, listen: false);

      final newItems = await chatsPublicosRepository.buscarComunidadesPaginadas(
        pageSize: _pageSize,
        lastDocument: lastDocument,
      );

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newItems.isNotEmpty
            ? FirebaseFirestore.instance
                .collection('chatPublico')
                .doc(newItems.last['id'])
            : null;
        _pagingController.appendPage(
            newItems, nextPageKey as DocumentSnapshot<Object?>?);
      }
    } catch (error) {
      print('Erro ao buscar comunidades: $error');
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comunidades'),
      ),
      body: PagedGridView<DocumentSnapshot?, Map<String, dynamic>>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
          itemBuilder: (context, item, index) {
            final docId = item['id'] ?? 'Sem nome'; // Obtém o ID do documento
            return GestureDetector(
              onTap: () {
                // Navega para a tela de chat, passando o nome do chat
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(chatNome: docId),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    item['imagemUrl'] != null
                        ? Image.network(
                            item['imagemUrl'],
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image, size: 100),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            docId, // Nome do documento usado como o nome do chat
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            item['descricao'] ?? 'Sem descrição',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Algo deu errado'),
                ElevatedButton(
                  onPressed: () => _pagingController.refresh(),
                  child: Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Defina o número de colunas (2 no caso)
          crossAxisSpacing: 10, // Espaçamento horizontal entre os itens
          mainAxisSpacing: 10, // Espaçamento vertical entre os itens
          childAspectRatio: 1.0, // Ajuste o aspecto do tamanho dos itens
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CriarChatPage()),
          );
          if (resultado == true) {
            _pagingController.refresh(); // Atualiza a lista
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
