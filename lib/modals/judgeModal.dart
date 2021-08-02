// To parse this JSON data, do
//
//     final judgeModal = judgeModalFromJson(jsonString);

import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Map<String, JudgeModal> judgeModalFromJson(String str) =>
    Map.from(json.decode(str)).map(
        (k, v) => MapEntry<String, JudgeModal>(k, JudgeModal.fromSnapshot(v)));

String judgeModalToJson(Map<String, JudgeModal> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class JudgeModal {
  String key;
  String name;
  String uDeviceId;
  String uniqueId;
  String taskSecret;
  bool completed;

  JudgeModal({
    this.key,
    @required this.name,
    @required this.uDeviceId,
    @required this.uniqueId,
    @required this.taskSecret,
    @required this.completed,
  });

  JudgeModal.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        uDeviceId = snapshot.value["uDeviceId"],
        uniqueId = snapshot.value["uniqueId"],
        taskSecret = snapshot.value["taskSecret"],
        completed = snapshot.value["completed"];

  Map<String, dynamic> toJson() => {
        "name": name,
        "uDeviceId": uDeviceId,
        "uniqueId": uniqueId,
        "taskSecret": taskSecret,
        "completed": completed,
      };
}
