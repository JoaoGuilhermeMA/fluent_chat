// lib/presentation/widgets/ranking_card.dart
import 'package:fluent_chat/domain/entities/perfil.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/usuario_repository.dart';

class RankingCard extends StatefulWidget {
  @override
  _RankingCardState createState() => _RankingCardState();
}

class _RankingCardState extends State<RankingCard> {
  late String userId;
  late Future<Map<String, dynamic>?> _userData;

  @override
  Widget build(BuildContext context) {
    final usuarioRepository = Provider.of<UsuarioRepository>(context);

    userId = Provider.of<AuthRepository>(context, listen: false)
        .getCurrentUserEmail()!; // A linha para pegar o email do usuário logado

    return FutureBuilder<Perfil?>(
      future: usuarioRepository.buscarUsuario(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar dados do usuário'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Nenhum dado encontrado'));
        }

        final perfil = snapshot.data!;
        final progresso = _calcularProgresso(perfil.points);
        print("perfil.points: ${perfil.points}");

        return Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Seu Ranking',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  perfil.rank,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: _getRankColor(perfil.rank),
                  ),
                ),
                LinearProgressIndicator(
                  value: progresso,
                  backgroundColor: Colors.grey[300],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_getRankColor(perfil.rank)),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Navegar para a página de ranking completo
                  },
                  child: Text('Ver Ranking Completo'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _calcularProgresso(int points) {
    if (points >= 800) return 1.0; // Radiante
    if (points >= 600) return 0.8; // Diamante
    if (points >= 400) return 0.6; // Ouro
    if (points >= 200) return 0.4; // Prata
    return 0.2; // Bronze
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
