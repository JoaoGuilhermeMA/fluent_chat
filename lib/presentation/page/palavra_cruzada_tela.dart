import 'package:crossword_generator/crossword_generator.dart';
import 'package:fluent_chat/domain/repositories/palavra_cruzada_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PalavraCruzadaTela extends StatefulWidget {
  @override
  _PalavraCruzadaTela createState() => _PalavraCruzadaTela();
}

class _PalavraCruzadaTela extends State<PalavraCruzadaTela> {
  Function? _revealCurrentCellLetter;
  late Future<List<Map<String, dynamic>>> _futurePalavras;

  @override
  void initState() {
    super.initState();
    final palavraCruzada = Provider.of<PalavraCruzadaRepository>(
      context,
      listen: false,
    );
    _futurePalavras = palavraCruzada.buscarPalavrasAleatorias("Bronze");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Palavra Cruzada'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futurePalavras,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar palavras.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma palavra encontrada.'));
          }

          final palavras = snapshot.data!;
          return CrosswordWidget(
            words: palavras,
            style: CrosswordStyle(
              currentCellColor: Color.fromARGB(255, 84, 255, 129),
              wordHighlightColor: Color.fromARGB(255, 200, 255, 200),
              wordCompleteColor: Color.fromARGB(255, 255, 249, 196),
              cellTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              descriptionButtonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              cellBuilder:
                  (context, cell, isSelected, isHighlighted, isCompleted) {
                return Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: isCompleted
                        ? Color.fromARGB(255, 255, 249, 196)
                        : isSelected
                            ? Color.fromARGB(255, 84, 255, 129)
                            : isHighlighted
                                ? Color.fromARGB(255, 200, 255, 200)
                                : Colors.white,
                  ),
                  child: Text(
                    cell.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                );
              },
            ),
            onRevealCurrentCellLetter: (revealCurrentCellLetter) {
              _revealCurrentCellLetter = revealCurrentCellLetter;
            },
            onCrosswordCompleted: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('PARABÉNS!'),
                    content: Text('VOCÊ É FODA MEU PARCEIRO'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
