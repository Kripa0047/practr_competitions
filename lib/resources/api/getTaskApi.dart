import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practrCompetitions/common/common.dart';

// Future<dynamic> getTask(
//   BuildContext context,
//   String secretCode,
//   GlobalKey<ScaffoldState> scaffoldKey,
// ) async {
//   try {
//     var url =
//         'https://us-central1-competitionsapp-c1125.cloudfunctions.net/getTask';
//     var body = {
//       "query":
//           """ { task(secretCode: "${secretCode.toString()}") { taskId competetionId competetionName name Live} } """
//     };
// // taskId competetionId competetionName name
//     var headers = {
//       'Content-Type': 'application/json',
//     };
//     http.Response response = await http.post(
//       url,
//       body: jsonEncode(body),
//       headers: headers,
//     );
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       // print("response body is: ${data}");

//       data = data['data']['task'];

//       // print("response statusCode is: ${response.statusCode}");
//       print("response body is: ${data}");
//       // print("response request is: ${response.request}");
//       // print("response headers is: ${response.headers}");

//       if (data == null) {
//         print("data is null");
//         scaffoldKey.currentState.showSnackBar(SnackBar(
//           content: Text(
//             "Secret Code Not Found!",
//             style: TextStyle(
//               color: Colors.red,
//             ),
//           ),
//         ));
//         return false;
//       }

//       data = data[0];

//       if (!data['Live']) {
//         print("Round is not Live!!");
//         scaffoldKey.currentState.showSnackBar(SnackBar(
//           content: Text(
//             "Round is NOT live!",
//             style: TextStyle(
//               color: Colors.red,
//             ),
//           ),
//         ));
//         return false;
//       }

//       contestTitle = data["competetionName"];
//       competetionId = data["competetionId"];
//       taskId = data["taskId"];
//       taskTitle = data["name"];
//       return true;
//     } else if (response.statusCode == 404) {
//       scaffoldKey.currentState.showSnackBar(SnackBar(
//         content: Text(
//           "Not Found!",
//           style: TextStyle(
//             color: Colors.red,
//           ),
//         ),
//       ));
//       return false;
//     }
//   } catch (e) {
//     print("error is $e");
//     scaffoldKey.currentState.showSnackBar(SnackBar(
//       content: Text(
//         "No Internet Connectivity!",
//         style: TextStyle(
//           color: Colors.red,
//         ),
//       ),
//     ));
//     return false;
//   }
// }

Future<dynamic> getTask(
  BuildContext context,
  String secretCode,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  try {
    DataSnapshot _data = await FirebaseDatabase.instance
        .reference()
        .child('task/$secretCode')
        .once();

    if (_data.value == null) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Not Found!",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
      return false;
    }
    print("data is: ${_data.value.runtimeType}");
    var data = _data.value;
    if (data['Live'] == 0) {
      print("Round is not Live!!");
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Round is NOT live!",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
      return false;
    }

    contestTitle = data["competetionName"];
    competetionId = data["competetionId"];
    taskId = data["taskId"];
    taskTitle = data["name"];
    judgeOrgToken = data["orgToken"];
    print("contestTitle: $contestTitle");
    print("competetionId: $competetionId");
    print("taskId: $taskId");
    print("taskTitle: $taskTitle");
    return true;
  } catch (e) {
    print("error is $e");
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "No Internet Connectivity!",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ));
    return false;
  }
}
