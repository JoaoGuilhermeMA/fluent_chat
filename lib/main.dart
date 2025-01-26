import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_chat/data/service/tts_service.dart';
import 'package:fluent_chat/presentation/widgets/auth_checker.dart';
import 'package:fluent_chat/core/di/configure_providers.dart';
import 'package:fluent_chat/firebase_options.dart';
import 'package:fluent_chat/theme/theme.dart';
import 'package:fluent_chat/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura os providers
  final providers = await ConfigureProviders.createDependencyTree();

  final ttsService = TtsService();
  await ttsService.initialize();

  runApp(MyApp(providers: providers.providers));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.providers});

  final List<SingleChildWidget> providers;

  @override
  Widget build(BuildContext context) {
    // Cria o TextTheme uma única vez (evita recriação desnecessária)
    final textTheme = createTextTheme(context, "Roboto Flex", "Roboto");
    final theme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fluent Chat',
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: const AuthChecker(),
      ),
    );
  }
}
