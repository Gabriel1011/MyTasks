import 'package:flutter/material.dart';
import '../../../shared/models/task.dart';
import '../../../shared/repositories/task_repository.dart';

class TaskList extends StatelessWidget {
  final TaskRepository taskRepository;

  const TaskList({super.key, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: taskRepository.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma tarefa encontrada'));
        }

        final tasks = snapshot.data!;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  task.isCompleted = value ?? false;
                  taskRepository.updateTask(task);
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => taskRepository.deleteTask(task.id),
              ),
            );
          },
        );
      },
    );
  }
}
