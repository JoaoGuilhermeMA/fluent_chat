import 'package:fluent_chat/presentation/page/autentica%C3%A7%C3%A3o/login.dart';
import 'package:fluent_chat/presentation/page/autentica%C3%A7%C3%A3o/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool shouldShowLoginPage = true;

  void togglePages() {
    setState(() {
      shouldShowLoginPage = !shouldShowLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return shouldShowLoginPage
        ? LoginPage(
            onTap: togglePages,
          )
        : RegisterPage(
            onTap: togglePages,
          );
  }
}
