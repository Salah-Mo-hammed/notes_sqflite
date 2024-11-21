import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

abstract class TaskRepo {
  Future<FirebaseDataState<List<TaskEntity>>> getAllTasks();
  Future<FirebaseDataState<void>> addTask(TaskEntity task);
  Future<FirebaseDataState<void>> deleteTask(int taskId);
  Future<FirebaseDataState<void>> updateTask(TaskEntity task);
  Future<FirebaseDataState<TaskEntity>> getTaskById(int id);
  Future<FirebaseDataState<void>> autoDelete(int taskId);
  Future<FirebaseDataState<void>> deleteAll();
}
