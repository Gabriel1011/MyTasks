import 'package:flutter/material.dart';
import 'package:my_tasks_app/desktop_app/lib/screens/home_screen.dart';
import 'package:my_tasks_app/desktop_app/lib/services/window_service.dart';
import '../../../shared/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await WindowService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTasks Desktop',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6272A4),
        scaffoldBackgroundColor: const Color(0xFF282A36),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF44475A),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Color(0xFF282A36),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6272A4),
          secondary: Color(0xFFFF79C6),
          surface: Color(0xFF44475A),
          error: Color(0xFFFF5555),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
