import 'package:fluent_chat/data/service/auth_service.dart';
import 'package:fluent_chat/data/service/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatNome;

  const ChatScreen({Key? key, required this.chatNome}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UsuarioService _usuarioService = UsuarioService();

  // Função para enviar mensagem
  void _sendMessage(String senderId, String text) async {
    if (text.trim().isNotEmpty) {
      await _firestore
          .collection('chatPublico')
          .doc(widget.chatNome)
          .collection('mensagens')
          .add({
        'senderId': senderId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  // Função para buscar o nome do usuário pelo ID
  Future<String> _getUserName(String senderId) async {
    var user = await _usuarioService.buscarUsuario(senderId);
    return user?.name ?? 'Usuário Desconhecido';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatNome),
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatPublico')
                  .doc(widget.chatNome)
                  .collection('mensagens')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
                    var senderId = message['senderId'];
                    var text = message['text'];
                    var timestamp = message['timestamp']?.toDate();

                    return FutureBuilder<String>(
                      future: _getUserName(senderId),
                      builder: (context, nameSnapshot) {
                        if (!nameSnapshot.hasData) {
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

                        return ListTile(
                          title: Text(nameSnapshot.data!),
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
                    // Aqui você pode passar o ID do usuário logado
                    String senderId = AuthService().getCurrentUserEmail()!;
                    _sendMessage(senderId, _messageController.text);
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
