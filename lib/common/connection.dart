import 'package:connectivity/connectivity.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:judge/common/errorHandling.dart';

import 'common.dart';

// class CheckConnection extends StatefulWidget {
//   @override
//   _CheckConnectionState createState() => _CheckConnectionState();
// }

// class _CheckConnectionState extends State<CheckConnection> {
//   var subscription;

//   @override
//   void initState() {
//     super.initState();
//     subscription = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       print("Connection Status has Changed: $result");
//     });
//     connectivityResultFunction();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     subscription.cancel();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text("connection Status: $connectivityResult"),
//     );
//   }
// }

Future<bool> connectivityResultFunction() async {
  connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print("Connected to Mobile Network");
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print("Connected to WiFi");
    return true;
  } else {
    print("Unable to connect. Please Check Internet Connection");
    //  Fluttertoast();
    return false;
  }
}
