import 'package:fluent_chat/presentation/page/cursos/vocabulario_screen.dart';
import 'package:flutter/material.dart';

class CursosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título
            Text(
              "Cursos",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Botão de Vocabulário
            ElevatedButton(
              onPressed: () {
                // Navegar para a página de Vocabulário
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VocabularioPage()),
                );
              },
              child: Text("Vocabulário"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            SizedBox(height: 10),

            // Botão de Gramática
            ElevatedButton(
              onPressed: () {
                // Navegar para a página de Gramática
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GramaticaPage()),
                );
              },
              child: Text("Gramática"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            SizedBox(height: 10),

            // Botão de Escuta
            ElevatedButton(
              onPressed: () {
                // Navegar para a página de Escuta
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EscutaPage()),
                );
              },
              child: Text("Escuta"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            SizedBox(height: 10),

            // Botão de Fala
            ElevatedButton(
              onPressed: () {
                // Navegar para a página de Fala
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FalaPage()),
                );
              },
              child: Text("Fala"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Páginas de exemplo (você pode implementá-las posteriormente)
class VocabularioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExercisePage(phrase: "Hello world");
  }
}

class GramaticaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gramática"),
      ),
      body: Center(
        child: Text("Conteúdo de Gramática"),
      ),
    );
  }
}

class EscutaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escuta"),
      ),
      body: Center(
        child: Text("Conteúdo de Escuta"),
      ),
    );
  }
}

class FalaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fala"),
      ),
      body: Center(
        child: Text("Conteúdo de Fala"),
      ),
    );
  }
}
