// To parse this JSON data, do
//
//     final particiModal = particiModalFromJson(jsonString);

import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Map<String, Map<String, ParticiModal>> particiModalFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) =>
        MapEntry<String, Map<String, ParticiModal>>(
            k,
            Map.from(v).map((k, v) => MapEntry<String, ParticiModal>(
                k, ParticiModal.fromSnapshot(v)))));

String particiModalToJson(Map<String, Map<String, ParticiModal>> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k,
        Map.from(v).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))));

class ParticiModal {
  String key;
  String code;
  String competetionId;
  String competetionName;
  String email;
  int id;
  String participantId;
  double points;
  bool qualified;

  ParticiModal({
    @required this.key,
    @required this.code,
    @required this.competetionId,
    @required this.competetionName,
    @required this.email,
    @required this.id,
    @required this.participantId,
    @required this.points,
    @required this.qualified,
  });

  ParticiModal.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        code = snapshot.value["code"],
        competetionId = snapshot.value["competetionId"],
        competetionName = snapshot.value["competetionName"],
        email = snapshot.value["email"],
        id = snapshot.value["id"],
        participantId = snapshot.value["participantId"],
        points = snapshot.value["points"].toDouble(),
        qualified = snapshot.value["qualified"];

  Map<String, dynamic> toJson() => {
        "code": code,
        "competetionId": competetionId,
        "competetionName": competetionName,
        "email": email,
        "id": id,
        "participantId": participantId,
        "points": points,
        "qualified": qualified,
      };
}
