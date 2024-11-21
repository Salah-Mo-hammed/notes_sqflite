import 'package:notes_local/clean_tasks/data/data_source/local/sql_db.dart';
import 'package:notes_local/clean_tasks/data/models/task_model.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class HistoryDb {
  final SqlDb sqlDb;
  HistoryDb(this.sqlDb);

  Future<FirebaseDataState<List<TaskModel>>> getTaskHistory(int taskId) async {
    final db = await sqlDb.db;
    final result = await db!.query(
      'tasks_history',
      where: 'task_id = ?',
      whereArgs: [taskId],
      orderBy: 'updated_at DESC',
    );
    print(
        "******************************************************History fetched: $result");
    return FirebaseDataSuccess(
        result.map((e) => TaskModel.fromMap(e)).toList());
  }
}
