import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:notes_local/clean_tasks/data/data_source/local/local_data_source.dart';
import 'package:notes_local/clean_tasks/data/data_source/remote/task_data_source.dart';
import 'package:notes_local/clean_tasks/data/models/task_model.dart';
import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';
import 'package:notes_local/clean_tasks/domain/repo/task_repo.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class TaskRepoImpl implements TaskRepo {
  TaskLocalDataSource taskLocalDataSource;

  TaskRemoteDataSource taskRemoteDataSource;
  TaskRepoImpl(
      {required this.taskLocalDataSource, required this.taskRemoteDataSource});
  @override
  Future<FirebaseDataState<void>> addTask(TaskEntity task) async {
    TaskModel taskModel = TaskModel(
      id: task.id,
      title: task.title,
      desc: task.desc,
    );
    await taskLocalDataSource.addTask(taskModel);
    return taskRemoteDataSource.addTask(taskModel);
  }

  @override
  Future<FirebaseDataState<void>> deleteTask(int taskId) async {
    await taskLocalDataSource.deleteTask(taskId);

    return taskRemoteDataSource.deleteTask(taskId);
  }

  @override
  Future<FirebaseDataState<List<TaskEntity>>> getAllTasks() async {
    try {
      return taskRemoteDataSource.getAllTasks();
    } catch (e) {
      return taskLocalDataSource.getAllTasks();
    }
  }

  @override
  Future<FirebaseDataState<TaskEntity>> getTaskById(int id) async {
    try {
      FirebaseDataState<TaskModel> remotlyTask =
          await taskRemoteDataSource.getTaskById(id);
      return FirebaseDataSuccess(remotlyTask.data!.toEntity());
    } catch (e) {
      return FirebaseDataFaild(FirebaseException(plugin: "no such element"));
    }
  }

  @override
  Future<FirebaseDataState<void>> updateTask(TaskEntity task) async {
    TaskModel taskModel =
        TaskModel(id: task.id, title: task.title, desc: task.desc);
    await taskLocalDataSource.addTask(taskModel);
    return taskRemoteDataSource.updateTask(taskModel);
  }

  @override
  Future<FirebaseDataState<void>> autoDelete(int taskId) async {
    await Future.delayed(const Duration(seconds: 300));
    return taskRemoteDataSource.autoDelete(taskId);
  }

  @override
  Future<FirebaseDataState<void>> deleteAll() async {
    return await taskLocalDataSource.deleteAll();
  }
}
