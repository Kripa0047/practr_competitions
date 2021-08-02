// To parse this JSON data, do
//
//     final roundModal = roundModalFromJson(jsonString);

import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Map<String, RoundModal> roundModalFromJson(String str) =>
    Map.from(json.decode(str)).map(
        (k, v) => MapEntry<String, RoundModal>(k, RoundModal.fromSnapshot(v)));

String roundModalToJson(Map<String, RoundModal> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class RoundModal {
  String key;
  int live;
  String competetionId;
  String competetionName;
  String name;
  String secretCode;
  List<Skill> skills;
  String taskId;
  int weightage;

  RoundModal({
    this.key,
    @required this.live,
    @required this.competetionId,
    @required this.competetionName,
    @required this.name,
    @required this.secretCode,
    @required this.skills,
    @required this.taskId,
    @required this.weightage,
  });

  RoundModal.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        live = snapshot.value["Live"],
        competetionId = snapshot.value["competetionId"],
        competetionName = snapshot.value["competetionName"],
        name = snapshot.value["name"],
        secretCode = snapshot.value["secretCode"],
        skills = snapshot.value["skills"] == null
            ? null
            : List<Skill>.from(
                snapshot.value["skills"].map((x) => Skill.fromJson(x))),
        taskId = snapshot.value["taskId"],
        weightage = snapshot.value["weightage"];

  Map<String, dynamic> toJson() => {
        "Live": live,
        "competetionId": competetionId,
        "competetionName": competetionName,
        "name": name,
        "secretCode": secretCode,
        "skills": List<dynamic>.from(skills.map((x) => x.toJson())),
        "taskId": taskId,
        "weightage": weightage,
      };
}

class Skill {
  int maxScore;
  String name;

  Skill({
    @required this.maxScore,
    @required this.name,
  });

  factory Skill.fromJson(Map<dynamic, dynamic> json) => Skill(
        maxScore: json["maxScore"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "maxScore": maxScore,
        "name": name,
      };
}
