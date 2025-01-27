import 'package:fluent_chat/domain/repositories/gramatica_repository.dart';
import 'package:fluent_chat/presentation/page/cursos/topico_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/data/models/topico_model.dart';

class GrammarScreen extends StatefulWidget {
  @override
  _GrammarScreenState createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  final Map<String, Color> rankColors = {
    'Bronze': Colors.brown,
    'Prata': Colors.grey,
    'Ouro': Colors.amber,
    'Diamante': Colors.lightBlueAccent,
    'Radiante': Colors.deepPurple,
  };

  String? selectedRank;
  List<TopicoModel>? topicos;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final gramaticaRepository = Provider.of<GramaticaRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aprenda Gramática',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Escolha um nível:',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Horizontal rank selector
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rankColors.keys.length,
              itemBuilder: (context, index) {
                String rank = rankColors.keys.elementAt(index);
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedRank = rank; // Atualiza o rank selecionado
                    });
                    // Busca os tópicos do rank selecionado
                    final topicos =
                        await gramaticaRepository.getTopicosByRank(rank);
                    setState(() {
                      this.topicos = topicos;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: rankColors[rank] ?? colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedRank == rank
                            ? colorScheme.onPrimary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    width: 150,
                    child: Center(
                      child: Text(
                        rank,
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Display topics based on selected rank
          Expanded(
            child: selectedRank == null
                ? Center(
                    child: Text(
                      'Selecione um nível acima para ver os tópicos!',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : topicos == null
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tópicos de ${selectedRank!}:',
                              style: textTheme.titleLarge?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: topicos!.length,
                                itemBuilder: (context, index) {
                                  final topico = topicos![index];
                                  return Card(
                                    elevation: 4.0,
                                    color: colorScheme.surfaceVariant,
                                    child: ListTile(
                                      title: Text(
                                        topico.title,
                                        style: textTheme.titleMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      subtitle: Text(
                                        topico.description,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      onTap: () {
                                        // Navega para a tela de detalhes do tópico
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TopicoDetailScreen(
                                                    topico: topico),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
