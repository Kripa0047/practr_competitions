import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/common/fancy_dialog_edit.dart';
import 'package:practrCompetitions/razorpay/payment.dart';
import 'package:practrCompetitions/utils/styles.dart';

checkPaid() async {
  DataSnapshot response = await FirebaseDatabase.instance
      .reference()
      .child('competetion')
      .child(orgCompetetionId)
      .child('paid')
      .once();

  var key = response.key;
  var value = response.value;
  print("key is: $key\nvalue is: $value");
  return value;
}

checkPayment(BuildContext context) async {
  return true; // comment this line when enable razorpay
  bool paid = await checkPaid();

  if (paid || (!razorpay_enabled)) return true;

  onSubmit(BuildContext context) {
    print("submittting");
    // CheckRazor();
    // Navigator.pop(context);
    Navigator?.of(context)?.push(
      MaterialPageRoute(
        builder: (context) => CheckRazor(),
      ),
      // (Route<dynamic> route) => false,
    );
  }

  // onSubmit(context);

  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (BuildContext context) {
      return FancyDialog(
        title: 'Hold On',
        animationType: FancyAnimation.TOP_BOTTOM,
        descreption: premiumCompAlert,
        okFun: () {
          return onSubmit(context);
        },
        okColor: primaryColor,
        ok: 'Buy 499/-',
        popScreen: false,
        cancelFun: () => Navigator.pop(context),
      );
    },
  );

  return false;
}
