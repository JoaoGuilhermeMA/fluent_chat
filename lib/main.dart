import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_chat/ui/widgets/auth_checker.dart';
import 'package:fluent_chat/core/di/configure_providers.dart';
import 'package:fluent_chat/firebase_options.dart';
import 'package:fluent_chat/theme/theme.dart';
import 'package:fluent_chat/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final data = await ConfigureProviders.createDependencyTree();

  runApp(MyApp(data: data));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.data});

  final ConfigureProviders data;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Roboto Flex", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aula',
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: const AuthChecker(),
      ),
    );
  }
}
