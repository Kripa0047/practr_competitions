import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';

Future<bool> createCompetetion(
  BuildContext context,
  String name,
  String organiserId,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  var _database = FirebaseDatabase.instance.reference().child('competetion');
  DatabaseReference pushHere = _database.push();
  var competetionId = pushHere.key;
  print("push id is:${pushHere.key}");
  var body = {
    "name": name,
    "id": competetionId,
    "organiserId": organiserId,
    "ongoing": true,
    "paid": false,
    "razorpay_payment_id": 'not-paid',
    "LinkLive": true,
  };
  try {
    await _database.child(competetionId).set(body);
    print("Competetion Created");
    orgCompetetionId = competetionId;
    orgCompetetionName = name;
    linkLive = true;
    await saveOrgData(
      organiserId,
      orgCompetetionId,
      orgCompetetionName,
    );
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
