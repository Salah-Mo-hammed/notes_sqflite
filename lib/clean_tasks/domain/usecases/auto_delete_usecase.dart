import 'package:notes_local/clean_tasks/domain/repo/task_repo.dart';

class AutoDeleteUsecase {
  TaskRepo taskRepo;
  AutoDeleteUsecase({required this.taskRepo});
  call(int taskId) {
    return taskRepo.autoDelete(taskId);
  }
}
