import 'package:flutter/material.dart';
import '../../../../shared/repositories/task_repository.dart';
import '../../shared/widgets/task_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskRepository taskRepository = TaskRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTasks Mobile'),
      ),
      body: TaskList(taskRepository: taskRepository),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar adição de tarefa
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
