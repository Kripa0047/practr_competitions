// To parse this JSON data, do
//
//     final judgeSheet = judgeSheetFromJson(jsonString);

import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

JudgeSheet judgeSheetFromJson(String str) =>
    JudgeSheet.fromSnapshot(json.decode(str));

String judgeSheetToJson(JudgeSheet data) => json.encode(data.toJson());

class JudgeSheet {
  String teamCode;
  List<Criterion> criteria;
  int total;

  JudgeSheet({
    @required this.teamCode,
    @required this.criteria,
    @required this.total,
  });

  JudgeSheet.fromSnapshot(DataSnapshot snapshot)
      : teamCode = snapshot.value["teamCode"],
        criteria = snapshot.value["criteria"] == null
            ? null
            : List<Criterion>.from(
                snapshot.value["criteria"].map((x) => Criterion.fromJson(x))),
        total = snapshot.value["total"];
  Map<String, dynamic> toJson() => {
        "teamCode": teamCode == null ? null : teamCode,
        "criteria": criteria == null
            ? null
            : List<dynamic>.from(criteria.map((x) => x.toJson())),
        "total": total == null ? null : total,
      };
}

class Criterion {
  String criteria;
  int score;
  int emoji;

  Criterion({
    @required this.criteria,
    @required this.score,
    @required this.emoji,
  });

  factory Criterion.fromJson(Map<String, dynamic> json) => Criterion(
        criteria: json["criteria"] == null ? null : json["criteria"],
        score: json["score"] == null ? null : json["score"],
        emoji: json["emoji"] == null ? null : json["emoji"],
      );

  Map<String, dynamic> toJson() => {
        "criteria": criteria == null ? null : criteria,
        "score": score == null ? null : score,
        "emoji": emoji == null ? null : emoji,
      };
}
