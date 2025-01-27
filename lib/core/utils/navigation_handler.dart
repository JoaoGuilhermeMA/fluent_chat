import 'package:fluent_chat/presentation/page/cursos/exercicio_page.dart';
import 'package:fluent_chat/presentation/page/cursos/gramatica_screen.dart';
import 'package:fluent_chat/presentation/page/cursos/palavra_cruzada_tela.dart';
import 'package:flutter/material.dart';

class NavigationHandler {
  static void navigateToPraticarPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PraticarPage()),
    );
  }

  static void navigateToGrammarScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GrammarScreen()),
    );
  }

  static void navigateToPalavraCruzadaTela(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PalavraCruzadaTela()),
    );
  }
}
