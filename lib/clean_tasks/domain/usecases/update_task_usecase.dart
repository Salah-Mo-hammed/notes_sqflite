
import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';
import 'package:notes_local/clean_tasks/domain/repo/task_repo.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class UpdateTaskUsecase {
  TaskRepo taskRepo;
  UpdateTaskUsecase({required this.taskRepo});
  Future<FirebaseDataState<void>> call(TaskEntity task) {
    return taskRepo.updateTask(task);
  }
}
