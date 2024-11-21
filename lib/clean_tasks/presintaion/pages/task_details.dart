// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, dead_code

import 'package:flutter/material.dart';
import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';
import 'package:notes_local/clean_tasks/presintaion/pages/task_history_page.dart';

class TaskDetails extends StatelessWidget {
  final TaskEntity detailedTask;

  TaskDetails({super.key, required this.detailedTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(),
                const SizedBox(height: 16),
                _buildDescriptionSection(),
                const SizedBox(height: 16),
                _buildIdSection(),
                const SizedBox(height: 16),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskHistoryPage(taskId: detailedTask.id),
                            ),
                          );
                        },
                        child: Text(
                          "edits",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          detailedTask.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          true ? Icons.check_circle : Icons.circle_outlined,
          color: true ? Colors.green : Colors.red,
          size: 28,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          detailedTask.desc,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildIdSection() {
    return Row(
      children: [
        const Icon(Icons.flag, color: Colors.orangeAccent),
        const SizedBox(width: 8),
        Text(
          'Id : ${detailedTask.id}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
