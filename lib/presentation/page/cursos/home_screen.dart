import 'package:fluent_chat/presentation/page/cursos/exercicio_page.dart';
import 'package:fluent_chat/presentation/page/cursos/gramatica_screen.dart';
import 'package:fluent_chat/presentation/page/cursos/palavra_cruzada_tela.dart';
import 'package:flutter/material.dart';
import '../../widgets/home_app_bar.dart';
import '../../widgets/ranking_card.dart';
import '../../widgets/section_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RankingCard(),
            SizedBox(height: 20.0),
            SectionCard(
              icon: Icons.school,
              title: 'Praticar',
              description: 'Pratique gramática, vocabulário e escuta.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PraticarPage()),
                );
              },
            ),
            SizedBox(height: 20.0),
            SectionCard(
              icon: Icons.book,
              title: 'Gramática',
              description: 'Aprenda conceitos da gramática da lingua inglesa.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GrammarScreen()),
                );
              },
            ),
            SizedBox(height: 20.0),
            SectionCard(
              icon: Icons.emoji_events,
              title: 'Desafio Diário',
              description: 'Complete o desafio de hoje e ganhe pontos.',
              onTap: () {
                _showDailyChallengeDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDailyChallengeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Desafio Diário"),
          content: Text(
              "Você deseja iniciar o desafio diário? Você terá apenas 5 minutos para completá-lo."),
          actions: <Widget>[
            TextButton(
              child: Text("Não"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text("Sim"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PalavraCruzadaTela()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
