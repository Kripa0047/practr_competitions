// To parse this JSON data, do
//
//     final taskModal = taskModalFromJson(jsonString);

import 'dart:convert';
import 'package:meta/meta.dart';

import 'package:firebase_database/firebase_database.dart';

Map<String, TaskModal> taskModalFromJson(String str) =>
    Map.from(json.decode(str)).map(
        (k, v) => MapEntry<String, TaskModal>(k, TaskModal.fromSnapshot(v)));

String taskModalToJson(Map<String, TaskModal> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class TaskModal {
  String key;
  int live;
  String competetionId;
  String competetionName;
  String name;
  String secretCode;
  String taskId;
  int weightage;
  String orgToken;
  List<TaskSkill> skills;

  TaskModal({
    @required this.key,
    @required this.live,
    @required this.competetionId,
    @required this.competetionName,
    @required this.name,
    @required this.secretCode,
    @required this.taskId,
    @required this.weightage,
    @required this.skills,
    @required this.orgToken,
  });

  TaskModal.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        live = snapshot.value["Live"],
        competetionId = snapshot.value["competetionId"],
        competetionName = snapshot.value["competetionName"],
        name = snapshot.value["name"],
        secretCode = snapshot.value["secretCode"],
        taskId = snapshot.value["taskId"],
        weightage = snapshot.value["weightage"],
        orgToken = snapshot.value["orgToken"],
        skills = snapshot.value["skills"] == null
            ? null
            : List<TaskSkill>.from(
                snapshot.value["skills"].map((x) => TaskSkill.fromJson(x)));

  Map<String, dynamic> toJson() => {
        "Live": live,
        "competetionId": competetionId,
        "competetionName": competetionName,
        "name": name,
        "secretCode": secretCode,
        "taskId": taskId,
        "weightage": weightage,
        'orgToken': orgToken,
        "skills": List<dynamic>.from(skills.map((x) => x.toJson())),
      };
}

class TaskSkill {
  int maxScore;
  String name;

  TaskSkill({
    @required this.maxScore,
    @required this.name,
  });

  factory TaskSkill.fromJson(Map<dynamic, dynamic> json) => TaskSkill(
        maxScore: json["maxScore"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "maxScore": maxScore,
        "name": name,
      };
}
