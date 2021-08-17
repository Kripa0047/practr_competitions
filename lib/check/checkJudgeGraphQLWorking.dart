import 'dart:async';
import 'dart:convert';
//import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/resources/api/createJudgeApi.dart';

Future<bool> checkJudgeExist(
  BuildContext context,
  String name,
  String secretCode,
  String uDeviceId,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  var uniqueId = name;
  uniqueId = uniqueId.toUpperCase() + secretCode + uDeviceId;

  judgeUniqueId = uniqueId;
  print("checking Judge  Exist now uniqueId: $uniqueId name: $name");
//  var _database = FirebaseDatabase.instance.reference().child('judges');

  handleResponse() async {
    try {
      return await createJudge(
        context,
        name,
        secretCode,
        uDeviceId,
        scaffoldKey,
      );
    } catch (e) {
      errorDialog(
        context,
        "Oops",
        "Please check you are connected to internet",
      );
      return false;
    }
  }

  try {
    var url =
        'https://us-central1-competitionsapp-c1125.cloudfunctions.net/checkJudgeExist';
    var body = {'query': '{ organiser { name } }'};

    var headers = {
      'Content-Type': 'application/json',
    };
    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );
    print("response statusCode is: ${response.statusCode}");
    print("response body is: ${response.body}");
    print("response request is: ${response.request}");
    print("response headers is: ${response.headers}");
    return false; // just for check remove this at end
    // DataSnapshot data =
    //     await _database.orderByChild("uniqueId").equalTo(uniqueId).once();

    // if (data.value == null) {
    //   print("data is null");
    //   return handleResponse();
    // }
    // print("data here is: ${data.value}");

    // Iterable<dynamic> keyHere = data.value.keys;
    // List<String> keys = keyHere.map((key) => key.toString()).toList();
    // // print("keys are: $keys");
    // judgeKey = keys[0];
    // if (data.value[judgeKey]["completed"]) {
    //   print("judge has submitted the data.");
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text(
    //       "Judge has submitted data!",
    //       style: TextStyle(
    //         color: Colors.red,
    //       ),
    //     ),
    //   ));
    //   return false;
    // }
    // return true;
  } catch (e) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "Judge Already Exist!",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ));
    return false;
  }
}
