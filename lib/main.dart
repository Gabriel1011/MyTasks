import 'package:flutter/material.dart';
import 'package:my_tasks_app/desktop_app/screens/home_screen_desktop.dart';
import 'package:my_tasks_app/mobile_app/screens/home_screen_mobile.dart';
import 'package:my_tasks_app/shared/screems/auth_screen.dart';
import 'package:my_tasks_app/shared/services/auth_service.dart';
import 'package:my_tasks_app/shared/services/platform_service.dart';
import 'package:my_tasks_app/shared/themes/dracula_theme.dart';
import 'package:my_tasks_app/shared/utils/shared_preferences_service.dart';
import '../shared/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await PlatformService.initialize();
  await SharedPreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  build(BuildContext context) {
    return MaterialApp(
      title: 'MyTasks Desktop',
      theme: DRACULA_THEME,
      initialRoute: AuthService().isAuthenticated() ? '/home' : '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => PlatformService.isDesktop
            ? const HomeScreenDesktop()
            : const HomeScreenMobile(),
      },
    );
  }
}
