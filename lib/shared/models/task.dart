import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final DateTime? createdAt;
  String title;
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      required this.createdAt,
      this.isCompleted = false});

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt!),
    };
  }
}
