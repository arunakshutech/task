import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Fetch all tasks from Firestore
  Future<void> loadTasks() async {
    try {
      setStateLoading(true);
      final snapshot = await FirebaseFirestore.instance.collection('tasks').get();
      _tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading tasks: $e');
    } finally {
      setStateLoading(false);
    }
  }

  // Add a new task to Firestore
  Future<void> addTask(Task task) async {
    try {
      setStateLoading(true);
      await FirebaseFirestore.instance.collection('tasks').add(task.toMap());
      await loadTasks(); // Refresh the task list
    } catch (e) {
      print('Error adding task: $e');
    } finally {
      setStateLoading(false);
    }
  }

  // Update an existing task in Firestore
  Future<void> updateTask(Task task) async {
    try {
      setStateLoading(true);
      await FirebaseFirestore.instance.collection('tasks').doc(task.id).update(task.toMap());
      await loadTasks(); // Refresh the task list
    } catch (e) {
      print('Error updating task: $e');
    } finally {
      setStateLoading(false);
    }
  }

  // Delete a task from Firestore
  Future<void> deleteTask(String taskId) async {
    try {
      setStateLoading(true);
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      await loadTasks(); // Refresh the task list
    } catch (e) {
      print('Error deleting task: $e');
    } finally {
      setStateLoading(false);
    }
  }

  // Move a task to "With-held Tasks"
  Future<void> moveTaskToWithheld(String taskId) async {
    try {
      setStateLoading(true);
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'status': 'With-held',
      });
      await loadTasks(); // Refresh the task list
    } catch (e) {
      print('Error moving task to with-held: $e');
    } finally {
      setStateLoading(false);
    }
  }

  // Set loading state
  void setStateLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}