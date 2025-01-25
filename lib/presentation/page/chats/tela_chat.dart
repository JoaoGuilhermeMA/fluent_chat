import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/chats_publicos_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';

class ChatScreen extends StatefulWidget {
  final String chatNome;

  const ChatScreen({Key? key, required this.chatNome}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Função para enviar mensagem
  void _sendMessage(String senderId, String text) async {
    if (senderId.isNotEmpty && text.trim().isNotEmpty) {
      final chatsPublicosRepository =
          Provider.of<ChatsPublicosRepository>(context, listen: false);
      await chatsPublicosRepository.adicionarMensagem(
        widget.chatNome,
        senderId,
        text,
      );
      _messageController.clear();
    }
  }

  // Função para buscar o nome do usuário pelo ID
  Future<String> _getUserName(String senderId) async {
    final usuarioRepository =
        Provider.of<UsuarioRepository>(context, listen: false);
    var user = await usuarioRepository.buscarUsuario(senderId);
    return user?.name ?? 'Usuário Desconhecido';
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    final chatsPublicosRepository =
        Provider.of<ChatsPublicosRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatNome),
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatsPublicosRepository.buscarMensagens(widget.chatNome),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar mensagens'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Nenhuma mensagem encontrada'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
                    var senderId = message['enviadoPor'] ?? 'Desconhecido';
                    var text = message['texto'] ?? '';
                    var timestamp = message['timestamp']?.toDate();

                    return FutureBuilder<String>(
                      future: _getUserName(senderId),
                      builder: (context, nameSnapshot) {
                        if (nameSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Carregando...'),
                            subtitle: Text(text),
                            trailing: Text(
                              timestamp != null
                                  ? '${timestamp.hour}:${timestamp.minute}'
                                  : '',
                            ),
                          );
                        }

                        if (nameSnapshot.hasError) {
                          return ListTile(
                            title: Text('Erro ao carregar nome do usuário'),
                            subtitle: Text(text),
                            trailing: Text(
                              timestamp != null
                                  ? '${timestamp.hour}:${timestamp.minute}'
                                  : '',
                            ),
                          );
                        }

                        return ListTile(
                          title:
                              Text(nameSnapshot.data ?? 'Usuário Desconhecido'),
                          subtitle: Text(text),
                          trailing: Text(
                            timestamp != null
                                ? '${timestamp.hour}:${timestamp.minute}'
                                : '',
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Campo de texto e botão de envio
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Obtém o ID do usuário logado
                    String? senderId = authRepository.getCurrentUserEmail();

                    if (senderId != null) {
                      _sendMessage(senderId, _messageController.text);
                    } else {
                      // Exibe uma mensagem de erro se o usuário não estiver autenticado
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Erro: Usuário não autenticado!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
