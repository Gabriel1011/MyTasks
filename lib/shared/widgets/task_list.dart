import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

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

        final tasks = snapshot.data!.toList();
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: InkWell(
                onDoubleTap: () => _editTask(context, task),
                child: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
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

  void _editTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        String updatedTitle = task.title;
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
            autofocus: true,
            decoration:
                const InputDecoration(hintText: 'Novo título da tarefa'),
            onChanged: (value) {
              updatedTitle = value;
            },
            controller: TextEditingController(text: task.title),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (updatedTitle.isNotEmpty && updatedTitle != task.title) {
                  task.title = updatedTitle;
                  taskRepository.updateTask(task);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
