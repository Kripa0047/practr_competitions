// To parse this JSON data, do
//
//     final roundSheet = roundSheetFromJson(jsonString);

import 'dart:convert';

RoundSheet roundSheetFromJson(String str) =>
    RoundSheet.fromJson(json.decode(str));

String roundSheetToJson(RoundSheet data) => json.encode(data.toJson());

class RoundSheet {
  String teamCode;
  List<Judge> judge;
  int total;
  double average;
  double weightedAverage;

  RoundSheet({
    this.teamCode,
    this.judge,
    this.total,
    this.average,
    this.weightedAverage,
  });

  factory RoundSheet.fromJson(Map<String, dynamic> json) => RoundSheet(
        teamCode: json["teamCode"] == null ? null : json["teamCode"],
        judge: json["judge"] == null
            ? null
            : List<Judge>.from(json["judge"].map((x) => Judge.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        average: json["average"] == null ? null : json["average"].toDouble(),
        weightedAverage: json["weightedAverage"] == null
            ? null
            : json["weightedAverage"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "teamCode": teamCode == null ? null : teamCode,
        "judge": judge == null
            ? null
            : List<dynamic>.from(judge.map((x) => x.toJson())),
        "total": total == null ? null : total,
        "average": average == null ? null : average,
        "weightedAverage": weightedAverage == null ? null : weightedAverage,
      };
}

class Judge {
  String name;
  int score;

  Judge({
    this.name,
    this.score,
  });

  factory Judge.fromJson(Map<String, dynamic> json) => Judge(
        name: json["name"] == null ? null : json["name"],
        score: json["score"] == null ? null : json["score"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "score": score == null ? null : score,
      };
}
