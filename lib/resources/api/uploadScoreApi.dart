import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/modals/scoreModal.dart';
import 'package:practrCompetitions/screens/Judge/sendPushFirebase.dart';
import 'package:http/http.dart' as http;

// 10 15 65 10
Future<bool> uploadScore(
  BuildContext context,
  ScoreModal scoreModal,
  GlobalKey<ScaffoldState> scaffoldKey,
) async {
  scoreModal.judgeUniqueId = judgeUniqueId;
  Map<String, dynamic> body = scoreModal.toMap();
  try {
    final stopwatch = Stopwatch()..start();

    String host = 'us-central1-competitionsapp-c1125.cloudfunctions.net';
    String path = '/uploadScoreFunc';
    Map<String, String> params = {
      'judgeKey': judgeKey,
      'competetionId': competetionId,
      'taskId': taskId,
      'judgeUniqueId': judgeUniqueId,
    };
    Uri uri = Uri(
      scheme: 'https',
      host: host,
      // port: 5000,
      path: path,
      queryParameters: params,
    );

    print("url come out of uri is: $uri");
    http.Response response = await http.post(
      uri,
      body: json.encode(body),
    );
    print("response by  dart: ${response.body}");
    var data = jsonDecode(response.body);

    print('upload score() executed in ${stopwatch.elapsed}');
    if (response.statusCode == 200) {
      if (data['mesg'] == 'SUCCESS') {
        sendAndRetrieveMessage(scoreModal.judgeName); // send push notifications
        return true;
      } else
      //  if (data['mesg'] == 'DELETED')
      {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Judge has been deleted! Contact Organiser",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ));
        return false;
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Data not uploaded ${data['error']}",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
      return false;
    }
  } catch (e) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        "Error Occured!$e",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ));
    return false;
  }
}
