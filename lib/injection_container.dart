import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_local/clean_tasks/data/data_source/local/local_data_source.dart';
import 'package:notes_local/clean_tasks/data/data_source/local/sql_db.dart';
import 'package:notes_local/clean_tasks/data/data_source/remote/task_data_source.dart';
import 'package:notes_local/clean_tasks/data/repo_impl/task_repo_impl.dart';
import 'package:notes_local/clean_tasks/domain/repo/task_repo.dart';
import 'package:notes_local/clean_tasks/domain/usecases/add_task_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/auto_delete_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/by_id_task_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/delete_all.dart';
import 'package:notes_local/clean_tasks/domain/usecases/delete_task_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:notes_local/clean_tasks/domain/usecases/update_task_usecase.dart';
import 'package:notes_local/clean_tasks/presintaion/bloc/task_bloc.dart';

GetIt sl = GetIt.instance;
Future<void> initilaizedDependencies() async {
  //! Dio (singletone)
  sl.registerSingleton<Dio>(Dio());

  //! data-> data sources (singletone)
  sl.registerSingleton<TaskRemoteDataSource>(WithFirebase());
  sl.registerSingleton<SqlDb>(SqlDb());

  sl.registerSingleton<TaskLocalDataSource>(TaskLocalDataSource(sl<SqlDb>()));

  //! domain-> repo (singletone)
  sl.registerSingleton<TaskRepo>(TaskRepoImpl(
      taskLocalDataSource: sl<TaskLocalDataSource>(),
      taskRemoteDataSource: sl<TaskRemoteDataSource>()));

  //! domain-> usecases (singletone)

  sl.registerSingleton<GetAllTasksUsecase>(
      GetAllTasksUsecase(taskRepo: sl<TaskRepo>()));

  sl.registerSingleton<AddTaskUsecase>(
      AddTaskUsecase(taskRepo: sl<TaskRepo>()));

  sl.registerSingleton<DeleteTaskUsecase>(
      DeleteTaskUsecase(taskRepo: sl<TaskRepo>()));

  sl.registerSingleton<UpdateTaskUsecase>(
      UpdateTaskUsecase(taskRepo: sl<TaskRepo>()));

  sl.registerSingleton<ByIdTaskUsecase>(
      ByIdTaskUsecase(taskRepo: sl<TaskRepo>()));

  sl.registerSingleton<AutoDeleteUsecase>(
      AutoDeleteUsecase(taskRepo: sl<TaskRepo>()));
  sl.registerSingleton<DeleteAllUsecase>(
      DeleteAllUsecase(taskRepo: sl<TaskRepo>()));
  //! blocs
  sl.registerFactory<TaskBloc>(() => TaskBloc(
      getAllTasksUsecase: sl<GetAllTasksUsecase>(),
      addTaskUsecase: sl<AddTaskUsecase>(),
      deleteTaskUsecase: sl<DeleteTaskUsecase>(),
      updateTaskUsecase: sl<UpdateTaskUsecase>(),
      byIdTaskUsecase: sl<ByIdTaskUsecase>(),
      autoDeleteUsecase: sl<AutoDeleteUsecase>(),
      deleteAllUsecase: sl<DeleteAllUsecase>()));
}
