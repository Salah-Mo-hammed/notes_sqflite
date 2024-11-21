// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_local/clean_tasks/data/models/task_model.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

abstract class TaskRemoteDataSource {
  Future<FirebaseDataState<List<TaskModel>>> getAllTasks();
  Future<FirebaseDataState<void>> addTask(TaskModel task);
  Future<FirebaseDataState<void>> deleteTask(int taskId);
  Future<FirebaseDataState<void>> updateTask(TaskModel task);
  Future<FirebaseDataState<TaskModel>> getTaskById(int id);
  Future<FirebaseDataState<void>> autoDelete(int id);
}

class WithFirebase implements TaskRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<FirebaseDataState<void>> addTask(TaskModel task) async {
    try {
      await firestore
          .collection('tasks')
          .doc(task.id.toString())
          .set(task.toJson());
      return const FirebaseDataSuccess<void>(null);
    } on FirebaseException catch (e) {
      return FirebaseDataFaild(e);
    }
  }

  @override
  Future<FirebaseDataState<void>> deleteTask(int taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId.toString()).delete();
      return const FirebaseDataSuccess(null);
    } on FirebaseException catch (e) {
      return FirebaseDataFaild(e);
    }
  }

  @override
  Future<FirebaseDataState<List<TaskModel>>> getAllTasks() async {
    try {
      final snapshot = await firestore.collection('tasks').get();

      final data =
          snapshot.docs.map((doc) => TaskModel.fromJson(doc.data())).toList();
      return FirebaseDataSuccess(data);
    } on FirebaseException catch (e) {
      return FirebaseDataFaild(e);
    }
  }

  @override
  Future<FirebaseDataState<TaskModel>> getTaskById(int id) async {
    try {
      final doc = await firestore.collection('tasks').doc(id.toString()).get();
      if (doc.exists) {
        return FirebaseDataSuccess(TaskModel.fromJson(doc.data()!));
      } else {
        return FirebaseDataFaild(FirebaseException(
            plugin: 'getby id exception in task data source'));
      }
    } on FirebaseException catch (e) {
      return FirebaseDataFaild(e);
    }
  }

  @override
  Future<FirebaseDataState<void>> updateTask(
    task,
  ) async {
    try {
      await firestore.collection('tasks').doc(task.id.toString()).update({
        'desc': task.desc,
        'id': task.id,
        'title': task.title,
      });
      return const FirebaseDataSuccess<void>(null);
    } on FirebaseException catch (e) {
      return FirebaseDataFaild(e);
    }
  }

  @override
  Future<FirebaseDataState<void>> autoDelete(int id) async {
    try {
      await firestore.collection("tasks").doc(id.toString()).delete();
      return const FirebaseDataSuccess<void>(null);
    } catch (e) {
      return FirebaseDataFaild(
          FirebaseException(plugin: "Failed to delete task"));
    }
  }
}
