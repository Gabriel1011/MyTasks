import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_tasks_app/shared/services/auth_service.dart';
import 'package:my_tasks_app/shared/services/platform_service.dart';
import 'package:window_manager/window_manager.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  Future<void> _submitForm() async {
    try {
      var function = _isLogin ? _auth.loginUsuario : _auth.createUser;
      await function(
        _emailController.text,
        _passwordController.text,
      );

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Erro ao realizar o login ou cadastro.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: GestureDetector(
          onPanStart: (_) =>
              PlatformService.isDesktop ? windowManager.startDragging() : () {},
          child: AppBar(
            title: Text(_isLogin ? 'Login' : 'Cadastro'),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(_isLogin ? 'Login' : 'Cadastrar'),
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin ? 'Criar uma conta' : 'Já tenho uma conta'),
            ),
          ],
        ),
      ),
    );
  }
}
