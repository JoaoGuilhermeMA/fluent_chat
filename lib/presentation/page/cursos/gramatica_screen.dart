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
    final gramaticaRepository = Provider.of<GramaticaRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprenda Gramática'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Escolha um nível:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      color: rankColors[rank] ?? Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedRank == rank
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    width: 150,
                    child: Center(
                      child: Text(
                        rank,
                        style: const TextStyle(
                          color: Colors.white,
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
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : topicos == null
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tópicos de ${selectedRank!}:',
                              style: const TextStyle(
                                fontSize: 20,
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
                                    child: ListTile(
                                      title: Text(topico.title),
                                      subtitle: Text(topico.description),
                                      trailing: const Icon(Icons.arrow_forward),
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
