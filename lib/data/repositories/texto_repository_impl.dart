import 'package:fluent_chat/data/service/texto_service.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';

class TextoRepositoryImpl extends TextoRepository {
  TextoService _textoService;

  TextoRepositoryImpl(this._textoService);

  @override
  Future<String> buscarFraseAleatoria(String rank) {
    return _textoService.buscarFraseAleatoria(rank);
  }
}
