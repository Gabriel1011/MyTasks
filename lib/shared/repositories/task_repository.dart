import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskRepository {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> getTasks() {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
              (doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> addTask(String title) async {
    await _tasksCollection.add({'title': title, 'isCompleted': false});
  }

  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}
