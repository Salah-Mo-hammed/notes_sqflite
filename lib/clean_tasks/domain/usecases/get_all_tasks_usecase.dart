
import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';
import 'package:notes_local/clean_tasks/domain/repo/task_repo.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class GetAllTasksUsecase {
  TaskRepo taskRepo;
  GetAllTasksUsecase({required this.taskRepo});
  Future<FirebaseDataState<List<TaskEntity>>> call() {
    return taskRepo.getAllTasks();
  }
}
