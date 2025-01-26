// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/ranking_card.dart';
import '../widgets/section_card.dart';

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
                // Navegar para a página de exercícios
              },
            ),
            SizedBox(height: 20.0),
            SectionCard(
              icon: Icons.book,
              title: 'Vocabulário',
              description: 'Aprenda novas palavras diariamente.',
              onTap: () {
                // Navegar para a página de vocabulário
              },
            ),
            SizedBox(height: 20.0),
            SectionCard(
              icon: Icons.emoji_events,
              title: 'Desafio Diário',
              description: 'Complete o desafio de hoje e ganhe pontos.',
              onTap: () {
                // Navegar para a página do desafio diário
              },
            ),
          ],
        ),
      ),
    );
  }
}
