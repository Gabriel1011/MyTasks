import 'package:flutter/material.dart';
import 'package:my_tasks_app/shared/widgets/notes/add_note_modal.dart';
import 'package:my_tasks_app/shared/widgets/tasks/add_task_modal.dart';

class AppFloatingAction extends StatefulWidget {
  final Function(String) addTask;
  final Function(String, String) addNote;

  const AppFloatingAction(
      {super.key, required this.addTask, required this.addNote});

  @override
  AppFloatingActionState createState() => AppFloatingActionState();
}

class AppFloatingActionState extends State<AppFloatingAction> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isExpanded ? 150 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniButton(
                  Icons.note,
                  () => showDialog(
                        context: context,
                        builder: (context) =>
                            AddNoteModal(addNote: widget.addNote),
                      ).then((_) => setState(() {
                            _isExpanded = false;
                          })),
                  'Note'),
              _buildMiniButton(
                  Icons.task,
                  () => showDialog(
                        context: context,
                        builder: (context) =>
                            AddTaskModal(addTask: widget.addTask),
                      ).then((_) => setState(() {
                            _isExpanded = false;
                          })),
                  'Task'),
            ],
          ),
        ),
        Focus(
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Icon(_isExpanded ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniButton(IconData icon, VoidCallback onPressed, String tag) {
    return FloatingActionButton.small(
      heroTag: tag,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
