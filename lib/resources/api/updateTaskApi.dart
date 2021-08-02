import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/modals/orgSkill.dart';

Future<bool> updateTask(
  BuildContext context,
  String name,
  int live,
  int weightage,
  List<OrgSkill> skills,
  String secretCode,
  String taskId,

  // GlobalKey<ScaffoldState> scaffoldKey,
) async {
  var _database = FirebaseDatabase.instance.reference().child('task');

  var body = {
    "name": name,
    "taskId": taskId,
    "competetionId": orgCompetetionId,
    "competetionName": orgCompetetionName,
    "Live": live,
    "secretCode": secretCode,
    "weightage": weightage,
    "skills": skills
        .map(
          (skill) => skill.toMap(),
        )
        .toList(),
  };
  try {
    await _database.child(taskId).update(body);
    print("Task Updated!!!");
    return true;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Data not saved.$e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 5,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return false;
  }
}

Future<bool> updateTaskToDraft(
  BuildContext context,
  int live,
  String taskId,

  // GlobalKey<ScaffoldState> scaffoldKey,
) async {
  var _database = FirebaseDatabase.instance.reference().child('task');
  var body = {
    "Live": live,
  };
  print("updating task from live to draft $taskId");
  try {
    await _database.child(taskId).update(body);
    print("Task Updated!!!");
    return true;
  } catch (e) {
    print("erroris: $e");
    Fluttertoast.showToast(
      msg: "Data not saved.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 5,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return false;
  }
}
