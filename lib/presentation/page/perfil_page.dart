import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_chat/data/service/auth_service.dart';
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
    // Obtendo o uid do usuário logado, que é único no Firebase Auth
    userId = Provider.of<AuthService>(context, listen: false)
        .getCurrentUserEmail()!; // A linha para pegar o email do usuário logado
    _userData =
        _getUserData(userId); // Buscando os dados do usuário usando o uid
  }

  // Método para buscar os dados do usuário no Firestore usando o uid
  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>?;
    } else {
      return null; // Caso o usuário não seja encontrado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
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
                const Text(
                  'Contatos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                user['contacts'] == null || (user['contacts'] as List).isEmpty
                    ? const Text('Nenhum contato encontrado.')
                    : Column(
                        children:
                            (user['contacts'] as List).map<Widget>((contactId) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(contactId)
                                .get(),
                            builder: (context, contactSnapshot) {
                              if (contactSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (contactSnapshot.hasError) {
                                return Text('Erro: ${contactSnapshot.error}');
                              }

                              var contactData = contactSnapshot.data?.data()
                                  as Map<String, dynamic>?;

                              if (contactData == null) return const SizedBox();

                              return ListTile(
                                title: Text(contactData['name']),
                                subtitle: Text(contactData['email']),
                              );
                            },
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 24),
                const Text(
                  'Conquistas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                user['achievements'] == null ||
                        (user['achievements'] as List).isEmpty
                    ? const Text('Nenhuma conquista registrada.')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (user['achievements'] as List)
                            .map<Widget>((achievement) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('• $achievement'),
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
