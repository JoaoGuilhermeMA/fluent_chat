import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';

class CadastrarPerfil extends StatefulWidget {
  final String userId; // Recebe o ID do usuário
  final String email; // Recebe o e-mail do registro

  const CadastrarPerfil({super.key, required this.userId, required this.email});

  @override
  State<CadastrarPerfil> createState() => _CadastrarPerfilState();
}

class _CadastrarPerfilState extends State<CadastrarPerfil> {
  final nameController = TextEditingController();
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> saveProfile() async {
    if (nameController.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    final usuarioRepository =
        Provider.of<UsuarioRepository>(context, listen: false);

    try {
      // Obter o userId
      final userId =
          authRepository.getCurrentUserEmail(); // Método retorna o userId
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Usuário não autenticado!')),
        );
        return;
      }

      // Criar o perfil no Firestore
      await usuarioRepository.criarUsuario(
        userId: userId,
        name: nameController.text,
        email: widget.email,
        profilePicture: selectedImage!,
        rank: "bronze",
      );

      // Exibir mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil criado com sucesso!')),
      );

      // Navegar para a próxima tela
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Complete seu perfil:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: selectedImage == null
                    ? const Center(child: Text('Selecione uma imagem'))
                    : Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveProfile,
              child: const Text('Salvar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
