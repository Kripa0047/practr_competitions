// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:judge/common/common.dart';

// // if false then move to name else name will be return
// Future<bool> getOldJudge(
//   BuildContext context,
//   String secretCode,
//   String uDeviceId,
//   GlobalKey<ScaffoldState> scaffoldKey,
// ) async {
//   // judgeUniqueId = uniqueId;

//   try {
//     var url =
//         'https://us-central1-competitionsapp-c1125.cloudfunctions.net/getJudge';
//     var body = {
//       "query":
//           """ { judge(taskSecret: "${secretCode.toString()}") { completed name judgeKey uDeviceId} } """
//     };

//     var headers = {
//       'Content-Type': 'application/json',
//     };
//     http.Response response = await http.post(
//       url,
//       body: jsonEncode(body),
//       headers: headers,
//     );
//     var responseData = jsonDecode(response.body);

//     print("response statusCode is: ${response.statusCode}");
//     // print("response body  is: ${data}");
//     // print("response request is: ${response.request}");
//     // print("response headers is: ${response.headers}");
//     if (response.statusCode != 200) {
//       scaffoldKey.currentState.showSnackBar(SnackBar(
//         content: Text(
//           "Error Resolving the getOldJudge",
//           style: TextStyle(
//             color: Colors.red,
//           ),
//         ),
//       ));
//       return false;
//     }
//     // print("data is: $data");
//     List data = responseData['data']['judge'];

//     if (data == null) {
//       print("data is null");
//       return false;
//     }
//     var _dataLen = data.length;
//     int i = 0;
//     for (i = 0; i < _dataLen; i++) {
//       if (uDeviceId == data[i]['uDeviceId']) {
//         if (!data[i]['completed']) {
//           judgeName = data[i]['name'];
//           judgeUniqueId = judgeName.toUpperCase() + uDeviceId;
//           judgeKey = data[i]['judgeKey'];
//           break;
//         }
//       }
//     }
//     if (i == _dataLen) {
//       return false;
//     }
//     return true;
//   } catch (e) {
//     // scaffoldKey.currentState.showSnackBar(SnackBar(
//     //   content: Text(
//     //     "Error Connecting to internet",
//     //     style: TextStyle(
//     //       color: Colors.red,
//     //     ),
//     //   ),
//     // ));
//     return false;
//   }
// }
