
import 'package:notes_local/clean_tasks/domain/repo/task_repo.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class DeleteAllUsecase {
  TaskRepo taskRepo;
  DeleteAllUsecase({required this.taskRepo});
  Future<FirebaseDataState<void>> call() {
    return taskRepo.deleteAll();
  }
}
