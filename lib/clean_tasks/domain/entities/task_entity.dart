//import 'package:pro_task_weather/clean_arch/domain/entities/weather_entity.dart';

class TaskEntity {
  int id;
  String title;
  String desc;
  final String? updatedAt;
  // final DateTime? deleteAt;

  TaskEntity({
    this.updatedAt,
    required this.id,
    required this.title,
    required this.desc,
    //   this.deleteAt
  });
}
