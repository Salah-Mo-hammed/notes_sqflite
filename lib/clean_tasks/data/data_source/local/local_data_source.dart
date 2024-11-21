import 'package:firebase_core/firebase_core.dart';
import 'package:notes_local/clean_tasks/data/data_source/local/sql_db.dart';
import 'package:notes_local/clean_tasks/data/models/task_model.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class TaskLocalDataSource {
  final SqlDb sqlDb;
  TaskLocalDataSource(this.sqlDb);
  Future<FirebaseDataState<List<TaskModel>>> getAllTasks() async {
    final db = await sqlDb.db;

    final result = await db!.query('tasks');
    return FirebaseDataSuccess(
        result.map((e) => TaskModel.fromJson(e)).toList());
  }

  Future<FirebaseDataState<void>> deleteAll() async {
    final db = await sqlDb.db;
    await db!.delete('tasks_history');
    return const FirebaseDataSuccess<void>(null);
  }

  Future<FirebaseDataState<void>> addTask(TaskModel task) async {
    final db = await sqlDb.db;
    await db!.insert(
        'tasks', {'task_id': task.id, 'title': task.title, 'desc': task.desc});
    await db.insert('tasks_history', {
      "task_id": task.id,
      "title": task.title,
      "desc": task.desc,
      "updated_at": DateTime.now().toIso8601String(),
    });
    return const FirebaseDataSuccess<void>(null);
  }

  Future<FirebaseDataState<void>> deleteTask(int taskId) async {
    final db = await sqlDb.db;
    await db!.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
    await db.delete('tasks_history', where: 'id = ?', whereArgs: [taskId]);
    return const FirebaseDataSuccess<void>(null);
  }

  Future<FirebaseDataState<void>> updateTask(TaskModel task) async {
    final db = await sqlDb.db;
    final currentTask = await getTaskById(task.id);
    // ignore: unnecessary_null_comparison
    if (currentTask != null && currentTask is FirebaseDataSuccess) {
      await db!
          .update("tasks", task.toMap(), where: 'id = ?', whereArgs: [task.id]);
      await db.insert("tasks_history", task.toMap());
    }

    return const FirebaseDataSuccess<void>(null);
  }

  Future<FirebaseDataState<TaskModel>> getTaskById(int id) async {
    final db = await sqlDb.db;
    final result = await db!.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return FirebaseDataSuccess(TaskModel.fromMap(result.first));
    }
    return FirebaseDataFaild(FirebaseException(
        message: "no thing here to watch man",
        plugin: "i dont know what to write"));
  }
}
