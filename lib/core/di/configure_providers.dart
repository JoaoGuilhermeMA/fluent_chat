import 'package:fluent_chat/data/repositories/auth_repository_impl.dart';
import 'package:fluent_chat/data/repositories/chats_publicos_impl.dart';
import 'package:fluent_chat/data/repositories/firebase_storage_repository_impl.dart';
import 'package:fluent_chat/data/repositories/texto_repository_impl.dart';
import 'package:fluent_chat/data/repositories/tts_repository_impl.dart';
import 'package:fluent_chat/data/repositories/usuario_repository_impl.dart';
import 'package:fluent_chat/data/service/auth_service.dart';
import 'package:fluent_chat/data/service/chats_publicos_services.dart';
import 'package:fluent_chat/data/service/firebase_storage_service.dart';
import 'package:fluent_chat/data/service/texto_service.dart';
import 'package:fluent_chat/data/service/tts_service.dart';
import 'package:fluent_chat/data/service/usuario_service.dart';
import 'package:fluent_chat/domain/repositories/auth_repository.dart';
import 'package:fluent_chat/domain/repositories/chats_publicos_repository.dart';
import 'package:fluent_chat/domain/repositories/firebase_storage_repository.dart';
import 'package:fluent_chat/domain/repositories/texto_repository.dart';
import 'package:fluent_chat/domain/repositories/tts_repository.dart';
import 'package:fluent_chat/domain/repositories/usuario_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    // Inicialize os serviços
    final authService = AuthService();
    final usuarioService = UsuarioService();
    final chatPublicoService = ChatPublicoService();
    final firebaseStorageService = FirebaseStorageService();
    final textoService = TextoService();
    final ttsService = TtsService();

    // Inicialize os repositórios com os serviços
    final authRepository = AuthRepositoryImpl(authService);
    final usuarioRepository = UsuarioRepositoryImpl(usuarioService);
    final chatsPublicosRepository = ChatsPublicosImpl(chatPublicoService);
    final firebaseStorageRepository =
        FirebaseStorageRepositoryImpl(firebaseStorageService);
    final textoRepository = TextoRepositoryImpl(textoService);
    final ttsRepository = TtsRepositoryImpl(ttsService);

    // Crie a lista de providers
    final providers = [
      // Registre os serviços
      Provider<AuthService>.value(value: authService),
      Provider<UsuarioService>.value(value: usuarioService),
      Provider<ChatPublicoService>.value(value: chatPublicoService),
      Provider<FirebaseStorageService>.value(value: firebaseStorageService),

      // Registre os repositórios (usando as interfaces, não as implementações)
      Provider<AuthRepository>.value(value: authRepository),
      Provider<UsuarioRepository>.value(value: usuarioRepository),
      Provider<ChatsPublicosRepository>.value(value: chatsPublicosRepository),
      Provider<FirebaseStorageRepository>.value(
          value: firebaseStorageRepository),
      Provider<TextoRepository>.value(value: textoRepository),
      Provider<TtsService>.value(value: ttsService),
      Provider<TtsRepository>.value(value: ttsRepository),
    ];

    // Retorne o objeto ConfigureProviders com a lista de providers
    return ConfigureProviders(providers: providers);
  }
}
