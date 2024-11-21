// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes_local/ad_manager/ad_manager.dart';
import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';
import 'package:notes_local/clean_tasks/presintaion/bloc/task_bloc.dart';
import 'package:notes_local/clean_tasks/presintaion/bloc/task_event.dart';
import 'package:notes_local/clean_tasks/presintaion/bloc/task_state.dart';
import 'package:notes_local/clean_tasks/presintaion/pages/task_details.dart';

class TasksPage extends StatefulWidget {
  bool isConnected;
  TasksPage({required this.isConnected, super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final TextEditingController descController = TextEditingController();
  late int lastElement;
  late int search;
  BannerAd? bannerAd;
  bool isLoaded = false;
  void load() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdManager.adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest())
      ..load();
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _buildAddTaskDialog(context);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Colors.blueAccent,
        actions: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: _buildTextField(
                  label: "Search for task",
                  controller: searchController,
                  onChanged: (value) {
                    try {
                      search = int.parse(value);
                      context.read<TaskBloc>().add(GetByIdEvent(id: search));
                      if (search > lastElement) {
                        context.read<TaskBloc>().add(const GetAllTasksEvent());
                      }
                    } catch (_) {
                      context.read<TaskBloc>().add(const GetAllTasksEvent());
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<TaskBloc>().add(GetByIdEvent(id: search));
                },
                icon: const Icon(Icons.search),
              ),
            ],
          )
        ],
      ),
      body: _bodyBuilder(),
    );
  }

  //////////////////////////////////////////! _bodyBuilder
  Column _bodyBuilder() {
    return Column(
      children: [
        Center(
          child: SizedBox(
              height: bannerAd!.size.height.toDouble(),
              width: bannerAd!.size.width.toDouble(),
              child: isLoaded ? AdWidget(ad: bannerAd!) : const SizedBox()),
        ),
        Expanded(
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskStateLoading) {
                context.read<TaskBloc>().add(const GetAllTasksEvent());
                return _buildCircularIndicator();
              } else if (state is TaskStateSearch) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 8,
                  child: ListView(children: [
                    ListTile(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TaskDetails(
                                detailedTask: state.searchId!,
                              ),
                            )),
                        title: Text(state.searchId!.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(state.searchId!.desc),
                        tileColor: Colors.grey[200]),
                  ]),
                );
              } else if (state is TaskStateDone) {
                return state.tasks!.isNotEmpty
                    ? _buildShowTasks(state)
                    : _exceptionHandler();
              } else if (state is TaskStateException) {
                return Center(
                  child: Text(
                    'Error: ${state.firebaseException.plugin}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                context.read<TaskBloc>().add(const GetAllTasksEvent());
                return _buildCircularIndicator();
              }
            },
          ),
        ),
      ],
    );
  }

  //////////////////////////////////////////! _exceptionHandler
  Center _exceptionHandler() {
    lastElement = 0;
    return const Center(
      child: Text(
        "No tasks available",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  //////////////////////////////////////////! _buildCircularIndicator
  Padding _buildCircularIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  //////////////////////////////////////////! _buildAddTaskDialog
  Future<void> _buildAddTaskDialog(BuildContext context) {
    titleController.clear();
    descController.clear();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Add Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(label: "Task Title", controller: titleController),
              _buildTextField(
                  label: "Task Description", controller: descController),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  context.read<TaskBloc>().add(const DeleteAllTasksEvent());
                  context.read<TaskBloc>().add(const GetAllTasksEvent());
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "delete all history",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TaskBloc>().add(
                      AddTaskEvent(
                        taskEntity: TaskEntity(
                          id: ++lastElement,
                          title: titleController.text,
                          desc: descController.text,
                        ),
                      ),
                    );
                context.read<TaskBloc>().add(const GetAllTasksEvent());
                context
                    .read<TaskBloc>()
                    .add(AutoDeleteTaskEvent(taskId: lastElement));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text("Add Task"),
            ),
          ],
        );
      },
    );
  }

  //////////////////////////////////////////! _buildTextField
  TextFormField _buildTextField({
    required String label,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
  }

  //////////////////////////////////////////! _buildShowTasks
  ListView _buildShowTasks(TaskStateDone state) {
    lastElement = state.tasks!.last.id;

    return ListView.builder(
      itemCount: state.tasks!.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4,
          child: _buildTaskListTile(context, state, index),
        );
      },
    );
  }

  //////////////////////////////////////////! _buildTaskListTile
  ListTile _buildTaskListTile(
      BuildContext context, TaskStateDone state, int index) {
    return ListTile(
      trailing: IconButton(
          onPressed: () {
            context
                .read<TaskBloc>()
                .add(DeleteTaskEvent(taskEntity: state.tasks![index]));
            context.read<TaskBloc>().add(const GetAllTasksEvent());
          },
          icon: const Icon(Icons.delete)),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TaskDetails(
            detailedTask: state.tasks![index],
          ),
        ));
      },
      leading: IconButton(
        onPressed: () {
          _buildUpdateTaskDialog(context, state, index);
        },
        icon: const Icon(Icons.edit),
      ),
      title: Text(state.tasks![index].title,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(state.tasks![index].desc),
      tileColor: Colors.grey[200],
    );
  }

  //////////////////////////////////////////! _buildUpdateTaskDialog
  Future<void> _buildUpdateTaskDialog(
      BuildContext context, TaskState state, int index) {
    titleController.clear();
    descController.clear();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Update Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(label: "Task Title", controller: titleController),
              _buildTextField(
                  label: "Task Description", controller: descController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              //////////////////////////////////////! UpdateTaskEvent
              onPressed: () {
                TaskEntity updatedTask = TaskEntity(
                    id: state.taskList![index].id,
                    title: titleController.text,
                    desc: descController.text);
                context.read<TaskBloc>().add(
                      UpdateTaskEvent(
                        task: updatedTask,
                      ),
                    );
                context.read<TaskBloc>().add(const GetAllTasksEvent());
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text("Update Task"),
            ),
          ],
        );
      },
    );
  }
}
