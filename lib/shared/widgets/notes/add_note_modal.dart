import 'package:flutter/material.dart';

class AddNoteModal extends StatelessWidget {
  final Function(String, String) addNote;

  const AddNoteModal({super.key, required this.addNote});

  @override
  Widget build(BuildContext context) {
    String title = '';
    String content = '';

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Adicionar Nota'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Título'),
            onChanged: (value) {
              title = value;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(hintText: 'Conteúdo'),
            maxLines: 3,
            onChanged: (value) {
              content = value;
            },
          ),
        ],
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
            if (title.isNotEmpty && content.isNotEmpty) {
              addNote(title, content);
            }
            Navigator.pop(context);
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
