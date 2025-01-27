import 'package:fluent_chat/data/models/topico_model.dart';

abstract class GramaticaRepository {
  Future<List<TopicoModel>> getTopicosByRank(String rank);
  Future<List<String>> getRanks();
}
