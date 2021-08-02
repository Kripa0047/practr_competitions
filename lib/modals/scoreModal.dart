// To parse this JSON data, do
//
//     final scoreModal = scoreModalFromJson(jsonString);

import 'dart:convert';

class ScoreModal {
  String judgeName;
  String taskSecret;
  String taskId;
  String competetionId;
  String judgeUniqueId;
  List<User> user;

  ScoreModal({
    this.judgeName,
    this.taskSecret,
    this.taskId,
    this.competetionId,
    this.judgeUniqueId,
    this.user,
  });

  factory ScoreModal.fromJson(String str) =>
      ScoreModal.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScoreModal.fromMap(Map<String, dynamic> json) => ScoreModal(
        judgeName: json["judgeName"] == null ? null : json["judgeName"],
        taskSecret: json["taskSecret"] == null ? null : json["taskSecret"],
        taskId: json["taskId"] == null ? null : json["taskId"],
        competetionId:
            json["competetionId"] == null ? null : json["competetionId"],
        judgeUniqueId:
            json["judgeUniqueId"] == null ? null : json["judgeUniqueId"],
        user: json["user"] == null
            ? null
            : List<User>.from(json["user"].map((x) => User.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "judgeName": judgeName == null ? null : judgeName,
        "taskSecret": taskSecret == null ? null : taskSecret,
        "taskId": taskId == null ? null : taskId,
        "competetionId": competetionId == null ? null : competetionId,
        "judgeUniqueId": judgeUniqueId == null ? null : judgeUniqueId,
        "user": user == null
            ? null
            : List<dynamic>.from(user.map((x) => x.toMap())),
      };
}

class User {
  String email;
  String id;
  String teamCode;
  String name;
  String mesg;
  bool qualified;
  List<Skill> skill;
  int total;

  User({
    this.email,
    this.id,
    this.teamCode,
    this.name,
    this.mesg,
    this.qualified,
    this.skill,
    this.total,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        email: json["email"] == null ? null : json["email"],
        id: json["id"] == null ? null : json["id"],
        teamCode: json["teamCode"] == null ? null : json["teamCode"],
        name: json["name"] == null ? null : json["name"],
        mesg: json["mesg"] == null ? null : json["mesg"],
        qualified: json["qualified"] == null ? null : json["qualified"],
        skill: json["skill"] == null
            ? null
            : List<Skill>.from(json["skill"].map((x) => Skill.fromMap(x))),
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toMap() => {
        "email": email == null ? null : email,
        "id": id == null ? null : id,
        "teamCode": teamCode == null ? null : teamCode,
        "name": name == null ? null : name,
        "mesg": mesg == null ? null : mesg,
        "qualified": qualified == null ? null : qualified,
        "skill": skill == null
            ? null
            : List<dynamic>.from(skill.map((x) => x.toMap())),
        "total": total == null ? null : total,
      };
}

class Skill {
  int emoji;
  String name;
  int score;

  Skill({
    this.emoji,
    this.name,
    this.score,
  });

  factory Skill.fromJson(String str) => Skill.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Skill.fromMap(Map<String, dynamic> json) => Skill(
        emoji: json["emoji"] == null ? null : json["emoji"],
        name: json["name"] == null ? null : json["name"],
        score: json["score"] == null ? null : json["score"],
      );

  Map<String, dynamic> toMap() => {
        "emoji": emoji == null ? null : emoji,
        "name": name == null ? null : name,
        "score": score == null ? null : score,
      };
}
