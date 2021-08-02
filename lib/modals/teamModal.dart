// To parse this JSON data, do
//
//     final teamModal = teamModalFromJson(jsonString);

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

TeamModal teamModalFromJson(String str) =>
    TeamModal.fromSnapshot(json.decode(str));

String teamModalToJson(TeamModal data) => json.encode(data.toJson());

class TeamModal {
  String key;
  String code;
  String competetionId;
  String competetionName;
  Map<dynamic, dynamic> data;
  String phoneNo;
  int id;
  String participantId;
  double points;
  bool qualified;

  TeamModal({
    @required this.key,
    this.code,
    this.competetionId,
    this.competetionName,
    this.data,
    this.phoneNo,
    this.id,
    this.participantId,
    this.points,
    this.qualified,
  });

  TeamModal.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        code = snapshot.value["code"],
        competetionId = snapshot.value["competetionId"],
        competetionName = snapshot.value["competetionName"],
        data = snapshot.value["data"] == null ? null : snapshot.value["data"],
        phoneNo = snapshot.value["phoneNo"],
        id = snapshot.value["id"],
        participantId = snapshot.value["participantId"],
        points = snapshot.value["points"].toDouble(),
        qualified = snapshot.value["qualified"];

  Map<String, dynamic> toJson() => {
        "code": code,
        "competetionId": competetionId,
        "competetionName": competetionName,
        "data": data,
        "phoneNo": phoneNo,
        "id": id,
        "participantId": participantId,
        "points": points,
        "qualified": qualified,
      };
}

class ScoreInfo {
  String judgeName;
  String uniqueId;
  int score;

  ScoreInfo({
    this.judgeName,
    this.uniqueId,
    this.score,
  });

  factory ScoreInfo.fromJson(Map<dynamic, dynamic> json) => ScoreInfo(
        judgeName: json["JudgeName"],
        uniqueId: json["uniqueId"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "JudgeName": judgeName,
        "uniqueId": uniqueId,
        "score": score,
      };
}
