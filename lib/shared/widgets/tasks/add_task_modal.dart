import 'package:flutter/material.dart';

class AddTaskModal extends StatelessWidget {
  final Function(String) addTask;

  const AddTaskModal({super.key, required this.addTask});

  @override
  Widget build(BuildContext context) {
    String newTask = '';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Adicionar Tarefa'),
      content: TextField(
        onChanged: (value) {
          newTask = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (newTask.isNotEmpty) {
              addTask(newTask);
            }
            Navigator.pop(context);
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
