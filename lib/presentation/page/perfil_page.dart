import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/presentation/page/relatorio_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late String userId;
  late Future<Map<String, dynamic>?> _userData;

  @override
  void initState() {
    super.initState();
    // Obtendo o email do usuário logado
    userId = Provider.of<AuthRepository>(context, listen: false)
        .getCurrentUserEmail()!;
    _userData = _getUserData(userId); // Buscando os dados do usuário
  }

  // Método para buscar os dados do usuário no Firestore usando o email
  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    } else {
      return null; // Caso o usuário não seja encontrado
    }
  }

  // Método para fazer logout
  void _logout() async {
    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    await authRepository.signOut();
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Redireciona para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Botão de logout
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Nenhum dado encontrado'));
          }

          var user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(
                        user['profilePicture'] ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] ?? 'Nome não disponível',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user['email'] ?? 'Email não disponível',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Botão para acessar o relatório
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RelatorioScreen(),
                        ),
                      );
                    },
                    child: const Text('Ver Relatório'),
                  ),
                ),
                const SizedBox(height: 16),
                // Botão de logout no corpo da página (opcional)
                Center(
                  child: ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Sair'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
