import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/chats_publicos_repository.dart';
import 'package:fluent_chat/domain/repositories/firebase_storage_repository.dart';

class CriarChatPage extends StatefulWidget {
  @override
  _CriarChatPageState createState() => _CriarChatPageState();
}

class _CriarChatPageState extends State<CriarChatPage> {
  final _formKey = GlobalKey<FormState>();
  final _chatNomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acessa os repositórios via Provider
    final chatsPublicosRepository =
        Provider.of<ChatsPublicosRepository>(context, listen: false);
    final storageRepository =
        Provider.of<FirebaseStorageRepository>(context, listen: false);
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Comunidade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _chatNomeController,
                decoration: InputDecoration(labelText: 'Nome da Comunidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da comunidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição da comunidade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              _image != null
                  ? Image.file(_image!, height: 100, width: 100)
                  : Text('Nenhuma imagem selecionada'),
              TextButton(
                onPressed: _pickImage,
                child: Text('Selecionar Imagem'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? adminEmail = authRepository.getCurrentUserEmail();
                    if (adminEmail != null && _image != null) {
                      String remotePath =
                          'chats/${_chatNomeController.text}.jpg';
                      await storageRepository.uploadFile(_image!, remotePath);
                      String? imageUrl =
                          await storageRepository.downloadFile(remotePath);

                      if (imageUrl != null) {
                        await chatsPublicosRepository.criarComunidade(
                          _chatNomeController.text,
                          _descricaoController.text,
                          adminEmail,
                          imageUrl,
                        );
                        Navigator.pop(
                            context, true); // Retorna true após a criação
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Erro ao obter URL da imagem')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Erro ao obter email do usuário ou imagem')),
                      );
                    }
                  }
                },
                child: Text('Criar Comunidade'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatNomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}
