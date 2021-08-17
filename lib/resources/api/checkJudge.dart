import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
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
  // print("checking Judge  Exist now uniqueId: $uniqueId name: $name");

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
    var body = {
      "query":
          """ { judge(uniqueId: "${uniqueId.toString()}") { completed } } """
    };

    var headers = {
      'Content-Type': 'application/json',
    };
    http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );
    
    var data = jsonDecode(response.body);

    print("response statusCode is: ${response.statusCode}");
    // print("response body  is: ${data}");
    // print("response request is: ${response.request}");
    // print("response headers is: ${response.headers}");
    if (response.statusCode != 200) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Error Resolving the secretCode",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
      return false;
    }
    data = data['data']['judge'];

    if (data == null) {
      print("data is null");
      return handleResponse();
    }
    judgeKey = data[0]['judgeKey'];
    data = data[0]['completed'];

    if (data) {
      print("judge has submitted the data.");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Judge has submitted data!",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
      return false;
    }
    return true;
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
