import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  late String userId;
  late Future<List<Map<String, dynamic>>> _partidas;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<AuthRepository>(context, listen: false)
        .getCurrentUserEmail()!;
    _partidas = _fetchPartidas();
  }

  Future<List<Map<String, dynamic>>> _fetchPartidas() async {
    // Use o Provider para acessar o usuarioRepository
    final usuarioRepository =
        Provider.of<UsuarioRepository>(context, listen: false);
    return await usuarioRepository.buscarHistorico(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Partidas'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _partidas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma partida encontrada.'));
          }

          List<Map<String, dynamic>> partidas = snapshot.data!;

          // Inverter a ordem das partidas
          partidas = partidas.reversed.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Desempenho das Partidas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: _buildBarGroups(partidas),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          top: BorderSide.none,
                          left: BorderSide(color: Colors.grey),
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) =>
                                Text(value.toInt().toString()),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < partidas.length) {
                                return Text(
                                  'Partida ${index + 1}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem(Colors.blue, 'Pontos Ganhos'),
                    const SizedBox(width: 20),
                    _buildLegendItem(Colors.red, 'Pontos Perdidos'),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Detalhes das Partidas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: partidas.length,
                    itemBuilder: (context, index) {
                      final partida = partidas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Partida ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Frase Escuta: ${partida['fraseEscuta']}'),
                              Text('Frase Fala: ${partida['fraseFala']}'),
                              Text(
                                  'Frase Vocabulário: ${partida['fraseVocabulario']}'),
                              Text(
                                  'Ganhou: ${partida['ganhou'] ? 'Sim' : 'Não'}'),
                              Text('Pontos Ganhos: ${partida['pontosGanhos']}'),
                              Text(
                                  'Pontos Perdidos: ${partida['pontosPerdidos']}'),
                              Text('Rank: ${partida['rank']}'),
                              Text(
                                  'Data: ${partida['timestamp'].toDate().toString()}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<Map<String, dynamic>> partidas) {
    return partidas.asMap().entries.map((entry) {
      int index = entry.key;
      var partida = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: partida['pontosGanhos']?.toDouble() ?? 0,
            color: Colors.blue,
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.blue],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 15,
          ),
          BarChartRodData(
            toY: partida['pontosPerdidos']?.toDouble() ?? 0,
            color: Colors.red,
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 15,
          ),
        ],
        barsSpace: 4,
      );
    }).toList();
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              // ignore: deprecated_member_use
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
