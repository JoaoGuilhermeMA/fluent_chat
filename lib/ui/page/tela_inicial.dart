import 'package:fluent_chat/ui/page/reconhecer_fala.dart';
import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, required this.title});

  final String title;

  @override
  State<TelaInicial> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TelaInicial> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    SpeechToTextExample(),
    Text('Carrinho'),
    Text('Comunidade'),
    Text("Perfil")
  ];
  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fluent Chat"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
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
