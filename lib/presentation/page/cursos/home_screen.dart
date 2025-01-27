import 'package:fluent_chat/core/utils/navigation_handler.dart';
import 'package:flutter/material.dart';
import '../../widgets/ranking_card.dart';
import '../../widgets/section_card.dart';

class HomePage extends StatelessWidget {
  static const EdgeInsets padding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.onPrimaryContainer,
                textColor: colorScheme.onPrimaryContainer,
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
                backgroundColor: colorScheme.secondaryContainer,
                iconColor: colorScheme.onSecondaryContainer,
                textColor: colorScheme.onSecondaryContainer,
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
                backgroundColor: colorScheme.tertiaryContainer,
                iconColor: colorScheme.onTertiaryContainer,
                textColor: colorScheme.onTertiaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String title, String message, Function onConfirm) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            title,
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
          content: Text(
            message,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Não",
                style: TextStyle(color: colorScheme.error),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text(
                "Sim",
                style: TextStyle(color: colorScheme.primary),
              ),
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
