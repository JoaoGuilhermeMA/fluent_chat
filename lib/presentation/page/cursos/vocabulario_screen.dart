// Exemplo de uso em um widget
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatelessWidget {
  final String userId;

  ExercisePage(String s, {required this.userId});

  @override
  Widget build(BuildContext context) {
    final usuarioRepository = context.read<UsuarioRepository>();

    return Scaffold(
      appBar: AppBar(title: Text('Exercício')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Simula um exercício concluído
            await usuarioRepository.atualizarProgresso(
              userId: userId,
              livesUsed: 2,
              correctAnswers: 8,
            );
            print('Progresso atualizado!');
          },
          child: Text('Completar Exercício'),
        ),
      ),
    );
  }
}
