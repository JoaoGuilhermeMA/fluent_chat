import 'package:fluent_chat/data/service/palavra_cruzada_service.dart';
import 'package:fluent_chat/domain/repositories/palavra_cruzada_repository.dart';

class PalavraCruzadaRepositoryImpl extends PalavraCruzadaRepository {
  final PalavraCruzadaService _palavraCruzadaService;

  PalavraCruzadaRepositoryImpl(this._palavraCruzadaService);

  @override
  Future<List<Map<String, String>>> buscarPalavrasAleatorias(String rank) {
    return _palavraCruzadaService.buscarPalavrasAleatorias(rank);
  }
}
