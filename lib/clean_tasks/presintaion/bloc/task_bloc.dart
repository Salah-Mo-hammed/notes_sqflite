import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_local/clean_tasks/domain/usecases/add_task_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/auto_delete_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/by_id_task_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/delete_all.dart';
import 'package:notes_local/clean_tasks/domain/usecases/delete_task_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/update_task_usecase.dart';
import 'package:notes_local/clean_tasks/presintaion/bloc/task_event.dart';
import 'package:notes_local/clean_tasks/presintaion/bloc/task_state.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class TaskBloc extends Bloc<TasksEvent, TaskState> {
  GetAllTasksUsecase getAllTasksUsecase;
  AddTaskUsecase addTaskUsecase;
  UpdateTaskUsecase updateTaskUsecase;
  DeleteTaskUsecase deleteTaskUsecase;
  ByIdTaskUsecase byIdTaskUsecase;
  AutoDeleteUsecase autoDeleteUsecase;
  DeleteAllUsecase deleteAllUsecase;
  TaskBloc(
      {required this.deleteAllUsecase,
      required this.getAllTasksUsecase,
      required this.updateTaskUsecase,
      required this.addTaskUsecase,
      required this.deleteTaskUsecase,
      required this.byIdTaskUsecase,
      required this.autoDeleteUsecase})
      : super(const TaskStateLoading()) {
    on<GetAllTasksEvent>(_onGetAllTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<GetByIdEvent>(_onGetById);
    on<AutoDeleteTaskEvent>(_onAutoDeleteTask);
    on<DeleteAllTasksEvent>(_onDeleteAll);
  }

  FutureOr<void> _onGetAllTasks(
      GetAllTasksEvent event, Emitter<TaskState> emit) async {
    final taskDataState = await getAllTasksUsecase.call();
    if (taskDataState is FirebaseDataSuccess && taskDataState.data != null) {
      emit(TaskStateDone(taskDataState.data));
    }
  }

  FutureOr<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    final dataState = await addTaskUsecase.call(event.taskEntity);
    if (dataState is FirebaseDataSuccess) {
      emit(const TaskStateRefreshed());
    }
  }

  FutureOr<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    final dataState = await updateTaskUsecase.call(event.task);
    if (dataState is FirebaseDataSuccess) {
      emit(const TaskStateRefreshed());
    }
  }

  FutureOr<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final dataState = await deleteTaskUsecase.call(event.taskEntity.id);
    if (dataState is FirebaseDataSuccess) {
      emit(const TaskStateRefreshed());
    }
  }

  FutureOr<void> _onGetById(GetByIdEvent event, Emitter<TaskState> emit) async {
    final dataState = await byIdTaskUsecase.call(event.id);
    if (dataState is FirebaseDataSuccess) {
      emit(TaskStateSearch(dataState.data!));
    }
  }

  FutureOr<void> _onAutoDeleteTask(
      AutoDeleteTaskEvent event, Emitter<TaskState> emit) async {
    final datastate = await autoDeleteUsecase.call(event.taskId);
    if (datastate is FirebaseDataSuccess) {
      emit(const TaskStateRefreshed());
    }
  }

  FutureOr<void> _onDeleteAll(
      DeleteAllTasksEvent event, Emitter<TaskState> emit) async {
    final dataState = await deleteAllUsecase.call();
      if (dataState is FirebaseDataSuccess) {
      emit(const TaskStateRefreshed());
    }
  
  }
}
