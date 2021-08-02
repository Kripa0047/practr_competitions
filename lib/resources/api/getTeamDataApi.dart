import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';

Future<dynamic> getTeamData(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  var _database = FirebaseDatabase.instance
      .reference()
      .child('participants/$competetionId');
  try {
    DataSnapshot data = await _database
        // .orderByChild("competetionId")
        // .equalTo(competetionId)
        .once();

    print("data TeamData is: ${data.value}");
    return data.value;
  } catch (e) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "Not Found! $e",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ));
    return false;
  }
}
