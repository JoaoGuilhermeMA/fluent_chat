import 'package:fluent_chat/core/utils/navigation_handler.dart';
import 'package:flutter/material.dart';
import '../../widgets/ranking_card.dart';
import '../../widgets/section_card.dart';

class HomePage extends StatelessWidget {
  static const EdgeInsets padding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RankingCard(),
              const SizedBox(height: 20.0),
              SectionCard(
                icon: Icons.school,
                title: 'Praticar',
                description: 'Pratique gramática, vocabulário e escuta.',
                onTap: () {
                  NavigationHandler.navigateToPraticarPage(context);
                },
              ),
              const SizedBox(height: 20.0),
              SectionCard(
                icon: Icons.book,
                title: 'Gramática',
                description:
                    'Aprenda conceitos da gramática da língua inglesa.',
                onTap: () {
                  NavigationHandler.navigateToGrammarScreen(context);
                },
              ),
              const SizedBox(height: 20.0),
              SectionCard(
                icon: Icons.emoji_events,
                title: 'Desafio Diário',
                description: 'Complete o desafio de hoje e ganhe pontos.',
                onTap: () {
                  _showConfirmationDialog(
                    context,
                    "Desafio Diário",
                    "Você deseja iniciar o desafio diário? Você terá apenas 5 minutos para completá-lo.",
                    () {
                      NavigationHandler.navigateToPalavraCruzadaTela(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String title, String message, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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
                onConfirm();
              },
            ),
          ],
        );
      },
    );
  }
}
