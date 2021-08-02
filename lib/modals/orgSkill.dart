// To parse this JSON data, do
//
//     final orgSkill = orgSkillFromJson(jsonString);

import 'dart:convert';

class OrgSkill {
  String name;
  int maxScore;

  OrgSkill({
    this.name,
    this.maxScore,
  });

  factory OrgSkill.fromJson(String str) => OrgSkill.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrgSkill.fromMap(Map<String, dynamic> json) => OrgSkill(
        name: json["name"] == null ? null : json["name"],
        maxScore: json["maxScore"] == null ? null : json["maxScore"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "maxScore": maxScore == null ? null : maxScore,
      };
}
