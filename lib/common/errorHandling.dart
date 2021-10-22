import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/fancy_dialog_edit.dart';
import 'package:practrCompetitions/utils/styles.dart';

errorDialog(
  BuildContext context,
  String title,
  String message,
) {
  return showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (_) => FancyDialog(
      title: title,
      animationType: FancyAnimation.TOP_BOTTOM,
      descreption: message,
      okColor: primaryColor,
      // cancelColor: Colors.transparent,
      // cancel: 'Can',
    ),
  );
}

copyDialog(
  BuildContext context,
  String title,
  String message,
  String text,
) {
  String shareString =
      'Hi! You’ve been invited to judge $orgCompetetionName. Download the Rethink Competitions App and use secret code $text to login and judge this competition.';
  okFunction() {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: "Secret code copied!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 5,
      backgroundColor: primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  cancelFunction() {
    Share.text('Secret Code', shareString, 'text/plain');
  }

  return showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) => FancyDialog(
      title: text,
      animationType: FancyAnimation.TOP_BOTTOM,
      descreption: message,
      okFun: okFunction,
      okColor: primaryColor,
      ok: 'Copy Code',
      cancelFun: cancelFunction,
      cancel: 'Share Code',
    ),
  );
}

confirmDialog(
  BuildContext context,
  String title,
  String message,
  var onTrue,
) {
  print("ite loding...");
  return showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (_) => FancyDialog(
      title: title,
      animationType: FancyAnimation.TOP_BOTTOM,
      descreption: message,
      okFun: () => onTrue(context),
      okColor: primaryColor,
      ok: 'Confirm',
    ),
  );
}

paymentDialog(
  BuildContext context,
  String title,
  String message,
  String okMesg,
  var onTrue,
) {
  print("ite loading...");
  showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        // return FancyDialog(
        //   title: 'Hold On',
        //   animationType: FancyAnimation.TOP_BOTTOM,
        //   descreption: 'You have found a premium feature of ₹499',
        //   okFun: () {
        //     return onTrue(context);
        //   },
        //   okColor: primaryColor,
        //   ok: 'Buy now',
        // );
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () => onTrue(context),
            ),
            Text('Cancel'),
          ],
        );
      });
}
