// lib/presentation/widgets/home_app_bar.dart
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Fluent Chat'),
      actions: [
        IconButton(
          icon: Icon(Icons.leaderboard),
          onPressed: () {
            // Navegar para a página de ranking
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
