//import 'package:pro_task_weather/clean_arch/data/models/weather_model.dart';

import 'package:notes_local/clean_tasks/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    super.updatedAt,
    required super.id,
    required super.title,
    required super.desc,
    //super.deleteAt
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      if (updatedAt != null) 'updated_at': updatedAt,
      //   if (deleteAt != null)
      //   'delete_at':
      //     deleteAt!.toIso8601String(),
    };
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      desc: desc, /*deleteAt: deleteAt */
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      updatedAt: map['updated_at'] as String?,
      //    deleteAt: map['delete_at'] != null ? DateTime.parse(map['delete_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "desc": desc,
        //     if (deleteAt != null) "delete_at": deleteAt!.toIso8601String(),
      };
  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        desc: json["desc"],
        //      deleteAt: json["delete_at"] != null ? DateTime.parse(json["delete_at"]): null,
      );
}
