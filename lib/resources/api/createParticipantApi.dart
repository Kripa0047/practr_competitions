import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/common/common.dart';

Future<bool> createParticipant(
  BuildContext context,
  var particiList,
  String code, {
  bool isToast = true,
}) async {
  //check name exist or not
  bool uniqueCode = true;
  for (int i = 0; i < particiList?.length ?? 0; i++) {
    print("particiList is: ${particiList[i].code}");
    String text = code.toUpperCase().replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String codeHere = particiList[i]
        .code
        .toUpperCase()
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    if (text == codeHere) {
      uniqueCode = false;
      break;
    }
  }

  if (!uniqueCode) {
    if (isToast)
      Fluttertoast.showToast(
        msg: "Participant Already exist!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 5,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    return false;
  }

  //till here

  var _database = FirebaseDatabase.instance
      .reference()
      .child('participants/$orgCompetetionId');
  DatabaseReference pushHere = _database.push();
  var participantId = pushHere.key;
  print("push id is create Participant:${pushHere.key}");

  var body = {
    "code": code,
    "competetionId": orgCompetetionId,
    "competetionName": orgCompetetionName,
    "email": "",
    "phoneNo": "",
    "participantId": participantId,
    // "id": orgParId, // save it in sharedPreferences
    "qualified": true,
    "points": 0.0,
  };
  try {
    await _database.child(participantId).set(body);
    orgParId++;
    print("New Participant Created!!!");
    if (isToast)
      Fluttertoast.showToast(
        msg: "$code Added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 5,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    return true;
  } catch (e) {
    if (isToast)
      Fluttertoast.showToast(
        msg: "Data not saved.$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 5,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    return false;
  }
}
