import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> createJudge(
  BuildContext context,
  String name,
  String secretCode,
  String uDeviceId,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  print("checking secret cdiii");
  var _uniqueId = name.toUpperCase() + secretCode + uDeviceId;

  var _database = FirebaseDatabase.instance.reference().child('judges');
  var pushHere = _database.push().key;
  _database = _database.child(pushHere);
  var body = {
    "name": name,
    "uniqueId": _uniqueId,
    "uDeviceId": uDeviceId,
    "taskSecret": secretCode,
    "completed": false,
    'judgeKey': pushHere,
  };

  // print("push id is:${pushHere.key}");
  try {
    await _database.set(body);
    judgeKey = pushHere;
    print("judge Created");

    /// can be checked
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences?.clear();

    await saveJudgeNameData(
      name,
      _uniqueId,
      pushHere,
    );
    await saveJudgeFirst(true);
    // int tLen = totalScore.length;
    // totalScore?.(0, tLen, 0);
    return true;
  } catch (e) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "Error Occured!",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ));
    return false;
  }
}
