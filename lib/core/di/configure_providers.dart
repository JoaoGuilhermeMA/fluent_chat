import 'package:fluent_chat/data/service/auth_service.dart';
import 'package:fluent_chat/data/service/usuario_service.dart'; // Importando o UsuarioService
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final authService = AuthService();
    final usuarioService = UsuarioService(); // Inicializando o UsuarioService

    return ConfigureProviders(providers: [
      Provider<AuthService>.value(value: authService),
      Provider<UsuarioService>.value(
          value: usuarioService), // Adicionando o UsuarioService
    ]);
  }
}
