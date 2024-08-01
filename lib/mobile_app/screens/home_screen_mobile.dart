import 'package:flutter/material.dart';
import 'package:my_tasks_app/shared/screems/home_screen.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTasks Mobile'),
      ),
      body: HomeScreen(),
    );
  }
}
