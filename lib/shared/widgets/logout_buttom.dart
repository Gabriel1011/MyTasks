import 'package:flutter/material.dart';
import 'package:my_tasks_app/shared/services/auth_service.dart';

class LogoutButton extends StatelessWidget {
  final AuthService _authService = AuthService();

  LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app),
      onPressed: () async {
        await _authService.logout();
        Navigator.of(context).pushReplacementNamed('/auth');
      },
      tooltip: 'Sair',
    );
  }
}
