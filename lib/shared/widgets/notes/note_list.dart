import 'package:flutter/material.dart';
import 'package:my_tasks_app/shared/models/note.dart';
import 'package:my_tasks_app/shared/repositories/note_repository.dart';

class NoteList extends StatelessWidget {
  final NoteRepository noteRepository;

  const NoteList({super.key, required this.noteRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: noteRepository.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma nota encontrada'));
        }

        final notes = snapshot.data!;
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _editNote(context, note),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => noteRepository.deleteNote(note.id),
              ),
            );
          },
        );
      },
    );
  }

  void _editNote(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        String updatedTitle = note.title;
        String updatedContent = note.content;
        return AlertDialog(
          title: const Text('Editar Nota'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Título'),
                controller: TextEditingController(text: note.title),
                onChanged: (value) {
                  updatedTitle = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(hintText: 'Conteúdo'),
                controller: TextEditingController(text: note.content),
                maxLines: 3,
                onChanged: (value) {
                  updatedContent = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (updatedTitle.isNotEmpty && updatedContent.isNotEmpty) {
                  note.title = updatedTitle;
                  note.content = updatedContent;
                  noteRepository.updateNote(note);
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
