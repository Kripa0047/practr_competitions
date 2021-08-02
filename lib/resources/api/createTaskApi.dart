import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/modals/orgSkill.dart';

Future<bool> createTask(
  BuildContext context,
  String name,
  int live,
  int weightage,
  List<OrgSkill> skills,
  String secretCode,
  // GlobalKey<ScaffoldState> scaffoldKey,
) async {
  var _database = FirebaseDatabase.instance.reference().child('task');
  DatabaseReference pushHere = _database.push();
  var taskId = secretCode;
  //  pushHere.key;
  print("push id is create Task:${pushHere.key}");
  FirebaseMessaging _fcm = FirebaseMessaging();
  String _orgToken = await _fcm.getToken();
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
    "orgToken": _orgToken,
  };
  try {
    await _database.child(taskId).set(body);
    print("New Task Created!!!");
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
