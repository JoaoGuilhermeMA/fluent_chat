// lib/presentation/pages/praticar_page.dart
import 'package:flutter/material.dart';
import 'vocabulario_page.dart';
import 'fala_page.dart';
import 'escuta_page.dart';

class PraticarPage extends StatefulWidget {
  @override
  _PraticarPageState createState() => _PraticarPageState();
}

class _PraticarPageState extends State<PraticarPage> {
  final List<Widget> _exercicios = [
    VocabularioPage(),
    EscutaPage(),
    FalaPage()
  ];
  int _indiceAtual = 0;

  void _proximoExercicio() {
    setState(() {
      _indiceAtual = (_indiceAtual + 1) % _exercicios.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Praticar'),
      ),
      body: _exercicios[_indiceAtual],
      floatingActionButton: FloatingActionButton(
        onPressed: _proximoExercicio,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
