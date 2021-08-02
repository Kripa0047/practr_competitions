// To parse this JSON data, do
//
//     final masterSheet = masterSheetFromJson(jsonString);

import 'dart:convert';

MasterSheet masterSheetFromJson(String str) =>
    MasterSheet.fromJson(json.decode(str));

String masterSheetToJson(MasterSheet data) => json.encode(data.toJson());

class MasterSheet {
  String teamCode;
  List<Average> average;
  double total;

  MasterSheet({
    this.teamCode,
    this.average,
    this.total,
  });

  factory MasterSheet.fromJson(Map<String, dynamic> json) => MasterSheet(
        teamCode: json["teamCode"] == null ? null : json["teamCode"],
        average: json["average"] == null
            ? null
            : List<Average>.from(
                json["average"].map((x) => Average.fromJson(x))),
        total: json["total"] == null ? null : json["total"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "teamCode": teamCode == null ? null : teamCode,
        "average": average == null
            ? null
            : List<dynamic>.from(average.map((x) => x.toJson())),
        "total": total == null ? null : total,
      };
}

class Average {
  String name;
  double score;

  Average({
    this.name,
    this.score,
  });

  factory Average.fromJson(Map<String, dynamic> json) => Average(
        name: json["name"] == null ? null : json["name"],
        score: json["score"] == null ? null : json["score"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "score": score == null ? null : score,
      };
}
