import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'criar_chat.dart';

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
      final query = FirebaseFirestore.instance
          .collection('chatPublico')
          .orderBy('descricao')
          .limit(_pageSize);

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

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = querySnapshot.docs.last;
        _pagingController.appendPage(newItems, nextPageKey);
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
            final docId =
                item['id'] ?? 'Sem nome'; // Obtém o ID do documento do Map
            return Card(
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
