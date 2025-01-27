// lib/presentation/screens/ranking_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/entities/perfil.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioRepository = Provider.of<UsuarioRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking Completo'),
      ),
      body: FutureBuilder<List<Perfil>>(
        future: usuarioRepository.buscarTodosUsuariosOrdenadosPorPontos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar o ranking'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum usuário encontrado'));
          }

          final usuarios = snapshot.data!;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final perfil = usuarios[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(perfil.profilePicture),
                ),
                title: Text(perfil.name),
                subtitle: Text('Pontos: ${perfil.points}'),
                trailing: Text(
                  perfil.rank,
                  style: TextStyle(
                    color: _getRankColor(perfil.rank),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank.toLowerCase()) {
      case 'radiante':
        return Colors.purple;
      case 'diamante':
        return Colors.blue;
      case 'ouro':
        return Colors.yellow;
      case 'prata':
        return Colors.grey;
      case 'bronze':
        return Colors.brown;
      default:
        return Colors.black;
    }
  }
}
