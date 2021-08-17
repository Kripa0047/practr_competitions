import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:practrCompetitions/common/common.dart';

final String serverToken =
    'AAAAgugFqP0:APA91bEunZG6uBfb51KpTJc0eGjfMJs8rq3db-c3-QYXST-_NcaFo9OGN0mklDMuNnn4P4yNtK2dQsURPYCk8_zI5OfNn3DhO8WlAxyodFgLt6BELfJgHwUS9F9lB-sDTPuYDfNRGpTt';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

// Future<Map<String, dynamic>>
void sendAndRetrieveMessage(String judgeName) async {
  print("mesg is sending to token: $judgeOrgToken");
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );

  http.Response response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'Judge has submitted the reponse.',
          'title': 'Under 25 Competetion'
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': judgeOrgToken,
        //  await firebaseMessaging.getToken(),
      },
    ),
  );
  // print("response is: ${response.statusCode}");
  // print("response body is: ${response.body}");
  // print("response is: ${response.statusCode}");

  final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
      print("mesg is: $message");
    },
  );

  print("mesg is sended to token: ${completer.future}");

  // return completer.future;
}
