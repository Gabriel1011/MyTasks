import 'package:flutter/material.dart';
import 'package:my_tasks_app/shared/widgets/task_floating_action.dart';

import '../../../../shared/repositories/task_repository.dart';
import '../../shared/widgets/task_list.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  @override
  Widget build(BuildContext context) {
    final TaskRepository taskRepository = TaskRepository();

    void addTask(String taskTitle) async {
      await taskRepository.addTask(taskTitle);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTasks Mobile'),
      ),
      body: TaskList(taskRepository: taskRepository),
      floatingActionButton: TaskFloatingActionButton(addTask: addTask),
    );
  }
}
