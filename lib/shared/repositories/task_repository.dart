import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskRepository {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> getTasks() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      List<Task> tasks = snapshot.docs
          .map(
              (doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      tasks.sort((a, b) {
        if (a.isCompleted == b.isCompleted) {
          return 0;
        }

        return a.isCompleted ? 1 : -1;
      });

      return tasks;
    });
  }

  Future<void> addTask(String title) async {
    await _tasksCollection.add({
      'title': title,
      'isCompleted': false,
      'createdAt': Timestamp.fromDate(DateTime.now())
    });
  }

  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }
}
