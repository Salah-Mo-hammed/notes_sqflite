import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';

abstract class TasksEvent {
  const TasksEvent();
}

class GetAllTasksEvent extends TasksEvent {
  const GetAllTasksEvent();
}

class DeleteAllTasksEvent extends TasksEvent {
  const DeleteAllTasksEvent();
}
class AddTaskEvent extends TasksEvent {
  TaskEntity taskEntity;
  AddTaskEvent({required this.taskEntity});
}
class AutoDeleteTaskEvent extends TasksEvent {
  int taskId;
  AutoDeleteTaskEvent({required this.taskId});
}


class UpdateTaskEvent extends TasksEvent {
  TaskEntity task;
  
  UpdateTaskEvent({
    required this.task
  });
}

class DeleteTaskEvent extends TasksEvent {
  TaskEntity taskEntity;

  DeleteTaskEvent({required this.taskEntity});
}

class GetByIdEvent extends TasksEvent {
  int id;
  GetByIdEvent({required this.id});
}

class ChangeStatusTaskEvent extends TasksEvent {
  int id;
  ChangeStatusTaskEvent({required this.id});
}
