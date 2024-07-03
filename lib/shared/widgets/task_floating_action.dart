import 'package:flutter/material.dart';

class TaskFloatingActionButton extends StatelessWidget {
  final Function addTask;
  const TaskFloatingActionButton({super.key, required this.addTask});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
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
          },
        );
      },
      tooltip: 'Adicionar Tarefa',
      child: const Icon(Icons.add),
    );
  }
}
