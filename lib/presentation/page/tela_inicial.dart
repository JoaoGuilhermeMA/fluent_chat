import 'package:fluent_chat/presentation/page/comunidade_page.dart';
import 'package:fluent_chat/presentation/page/cursos/cursos_page.dart';
import 'package:fluent_chat/presentation/page/perfil_page.dart';
import 'package:fluent_chat/presentation/page/reconhecer_fala.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, required this.title});

  final String title;

  @override
  State<TelaInicial> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TelaInicial> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    CursosPage(),
    SpeechToTextExample(),
    ComunidadePage(),
    PerfilPage(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Erro ao deslogar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fluent Chat"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Cursos"),
          NavigationDestination(icon: Icon(Icons.speaker), label: 'Fala'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Comunidade'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onDestinationSelected: _onItemSelected,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
