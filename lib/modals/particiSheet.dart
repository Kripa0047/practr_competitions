// To parse this JSON data, do
//
//     final particiSheet = particiSheetFromJson(jsonString);

import 'dart:convert';

ParticiSheet particiSheetFromJson(String str) =>
    ParticiSheet.fromJson(json.decode(str));

String particiSheetToJson(ParticiSheet data) => json.encode(data.toJson());

class ParticiSheet {
  String name;
  double score;

  ParticiSheet({
    this.name,
    this.score,
  });

  factory ParticiSheet.fromJson(Map<String, dynamic> json) => ParticiSheet(
        name: json["name"] == null ? null : json["name"],
        score: json["score"] == null ? null : json["score"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "score": score == null ? null : score,
      };
}
