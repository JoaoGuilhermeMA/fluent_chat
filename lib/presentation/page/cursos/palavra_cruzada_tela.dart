import 'package:crossword_generator/crossword_generator.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/palavra_cruzada_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Importe o pacote para usar Timer
import 'package:cloud_firestore/cloud_firestore.dart'; // Importe o Firestore

class PalavraCruzadaTela extends StatefulWidget {
  const PalavraCruzadaTela({super.key});

  @override
  _PalavraCruzadaTela createState() => _PalavraCruzadaTela();
}

class _PalavraCruzadaTela extends State<PalavraCruzadaTela> {
  late Future<List<Map<String, dynamic>>> _futurePalavras;
  int _timeLeft = 300; // 5 minutos em segundos
  late Timer _timer;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instância do Firestore

  @override
  void initState() {
    super.initState();
    final palavraCruzada = Provider.of<PalavraCruzadaRepository>(
      context,
      listen: false,
    );
    _futurePalavras = palavraCruzada.buscarPalavrasAleatorias("Bronze");

    // Inicia o timer
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel(); // Para o timer
        _showTimeUpDialog(); // Exibe o alerta de tempo esgotado
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Impede que o usuário feche o diálogo clicando fora
      builder: (context) {
        return AlertDialog(
          title: Text('TEMPO ESGOTADO!'),
          content: Text('Você não conseguiu completar o desafio a tempo.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context)
                    .pop(); // Volta para a tela anterior (HomeScreen)
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela o timer quando a tela é fechada
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Função para adicionar 100 pontos ao usuário
  Future<void> ganhouDesafio() async {
    try {
      final authRepository =
          Provider.of<AuthRepository>(context, listen: false);
      String? userId = authRepository.getCurrentUserEmail();

      // Referência ao documento do usuário
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Atualiza o campo 'points' incrementando 100 pontos
      await userRef.update({
        'points': FieldValue.increment(100),
      });

      print("100 pontos adicionados com sucesso!");
    } catch (e) {
      print("Erro ao adicionar pontos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Palavra Cruzada'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Tempo: ${_formatTime(_timeLeft)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
            onRevealCurrentCellLetter: (revealCurrentCellLetter) {},
            onCrosswordCompleted: () {
              _timer.cancel(); // Para o timer se o desafio for completado
              ganhouDesafio(); // Adiciona 100 pontos ao usuário
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
                          Navigator.of(context).pop(); // Fecha o diálogo
                          Navigator.of(context)
                              .pop(); // Volta para a tela anterior (HomeScreen)
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
