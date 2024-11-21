import 'package:flutter/material.dart';
import 'package:notes_local/clean_tasks/data/data_source/local/history_db.dart';
import 'package:notes_local/clean_tasks/data/data_source/local/sql_db.dart';
import 'package:notes_local/clean_tasks/data/models/task_model.dart';
import 'package:notes_local/data_state/firebase_data_state.dart';

class TaskHistoryPage extends StatelessWidget {
  final int taskId;

  const TaskHistoryPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final historyDb = HistoryDb(SqlDb());

    return Scaffold(
      appBar: AppBar(title: const Text('modification history')),
      body: FutureBuilder<FirebaseDataState<List<TaskModel>>>(
        future: historyDb.getTaskHistory(taskId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('error: ${snapshot.error}'));
          } else if (snapshot.data is FirebaseDataFaild) {
            return const Center(child: Text('no history for this task.'));
          }

          final history =
              (snapshot.data as FirebaseDataSuccess<List<TaskModel>>).data;


          return ListView.builder(
            itemCount: history!.length,
            itemBuilder: (context, index) {
              final task = history[index];
              
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.desc),
                trailing: Text(task.updatedAt ?? 'no updates yet'),
              );
            },
          );
        },
      ),
    );
  }
}
