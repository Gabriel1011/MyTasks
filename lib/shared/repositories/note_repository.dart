import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NoteRepository {
  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Stream<List<Note>> getNotes() {
    return _notesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      var notes = snapshot.docs
          .map(
              (doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return notes;
    });
  }

  Future<void> addNote(String title, String content) async {
    await _notesCollection.add({
      'title': title,
      'content': content,
      'createdAt': DateTime.now().toIso8601String()
    });
  }

  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }
}
