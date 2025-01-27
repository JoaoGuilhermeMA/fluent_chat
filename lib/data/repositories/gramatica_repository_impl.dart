import 'package:fluent_chat/data/models/topico_model.dart';
import 'package:fluent_chat/data/service/gramatica_service.dart';
import 'package:fluent_chat/domain/repositories/gramatica_repository.dart';
import 'package:flutter/material.dart';

class GramaticaRepositoryImpl extends GramaticaRepository {
  final GramaticaService gramaticaService;

  GramaticaRepositoryImpl(this.gramaticaService);

  @override
  Future<List<TopicoModel>> getTopicosByRank(String rank) async {
    try {
      return await gramaticaService.getTopicosByRank(rank);
    } catch (e) {
      debugPrint("Erro no repositório ao buscar tópicos: $e");
      throw Exception("Erro no repositório ao buscar tópicos");
    }
  }

  @override
  Future<List<String>> getRanks() async {
    try {
      return await gramaticaService.getRanks();
    } catch (e) {
      debugPrint("Erro no repositório ao buscar ranks: $e");
      throw Exception("Erro no repositório ao buscar ranks");
    }
  }
}
