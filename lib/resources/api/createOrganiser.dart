import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/function.dart';

Future<bool> createOrganiser(
  BuildContext context,
  String name,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  var _database = FirebaseDatabase.instance.reference().child('organiser');
  // DatabaseReference pushHere = _database.push();
  // var orgId = pushHere.key;
  // print("push id is:${pushHere.key}");
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  var uid = user.uid;

  try {
    FirebaseMessaging _fcm = FirebaseMessaging();
    String _fcmToken = await _fcm.getToken();
    var body = {
      "name": name,
      "id": uid,
      "token": _fcmToken,
      // "createdAt": FieldValue.server,
      "platform": checkPlatform(context),
    };
    await _database.child(uid).set(body);
    print("New Organiser Created!!!");
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
