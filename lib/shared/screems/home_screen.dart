import 'package:flutter/material.dart';
import 'package:my_tasks_app/shared/repositories/note_repository.dart';
import 'package:my_tasks_app/shared/widgets/notes/note_list.dart';
import 'package:my_tasks_app/shared/widgets/app_floating_action.dart';
import 'package:my_tasks_app/shared/widgets/tasks/task_list.dart';
import '../repositories/task_repository.dart';

class HomeScreen extends StatelessWidget {
  TaskRepository taskRepository = TaskRepository();
  NoteRepository noteRepository = NoteRepository();

  HomeScreen({super.key});

  void addTask(String taskTitle) async {
    await taskRepository.addTask(taskTitle);
  }

  void addNote(String tittle, String content) async {
    await noteRepository.addNote(tittle, content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _buildTaskList(),
                  _buildNotesList(),
                ],
              ),
            ),
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.task), text: 'Tarefas'),
                Tab(icon: Icon(Icons.note), text: 'Notas'),
              ],
              dividerColor: Colors.transparent,
            ),
          ],
        ),
      ),
      floatingActionButton:
          AppFloatingAction(addTask: addTask, addNote: addNote),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTaskList() {
    return TaskList(taskRepository: taskRepository);
  }

  Widget _buildNotesList() {
    return NoteList(noteRepository: noteRepository);
  }
}
