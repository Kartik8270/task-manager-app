import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  CollectionReference get _tasksCollection =>
      _firestore.collection('tasks');

  // Get all tasks for current user (real-time stream)
  Stream<List<TaskModel>> getTasksStream() {
  return _tasksCollection
      .where('userId', isEqualTo: _userId)
      .snapshots()
      .map((snapshot) {
        final tasks = snapshot.docs
            .map((doc) => TaskModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ))
            .toList();
        // Sort client-side instead
        tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return tasks;
      });
}

  // Add a new task
  Future<void> addTask(TaskModel task) async {
    try {
      await _tasksCollection.add(task.toMap());
    } on FirebaseException catch (e) {
      throw 'Failed to add task: ${e.message}';
    }
  }

  // Update an existing task
  Future<void> updateTask(TaskModel task) async {
    try {
      await _tasksCollection.doc(task.id).update(task.toMap());
    } on FirebaseException catch (e) {
      throw 'Failed to update task: ${e.message}';
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } on FirebaseException catch (e) {
      throw 'Failed to delete task: ${e.message}';
    }
  }

  // Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId, bool currentStatus) async {
    try {
      await _tasksCollection.doc(taskId).update({
        'isCompleted': !currentStatus,
      });
    } on FirebaseException catch (e) {
      throw 'Failed to update task status: ${e.message}';
    }
  }
}
