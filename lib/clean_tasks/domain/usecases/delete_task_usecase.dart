
import 'package:notes_local/clean_tasks/domain/repo/task_repo.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class DeleteTaskUsecase {
  TaskRepo taskRepo;
  DeleteTaskUsecase({required this.taskRepo});
  Future<FirebaseDataState<void>> call(int taskId) {
    return taskRepo.deleteTask(taskId);
  }
}
