import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/login/phone/OrgOtp.dart';
import 'package:practrCompetitions/login/phone/OrgPhone.dart';

String phoneNo = countryCode + organiserPhoneController.text;
String smsCode;
String verificationId;
int resendCode;
var contextHere;
final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
  verificationId = verId;
  print("auto000000000 retreive working");
};

final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
  verificationId = verId;
  resendCode = forceCodeResend;

  print("Code sent to: $phoneNo ");
  // Navigator.push(
  //   contextHere,
  //   MaterialPageRoute(
  //     builder: (BuildContext context) => OrganiserOTP(),
  //   ),
  // );
  OrganiserOTP();
  // smsCodeDialog(context).then((value) {
  //   // print("Signed In");
  // });
};

final PhoneVerificationCompleted verifiedSuccess = (AuthCredential credential) {
  print('Verified credential for: $phoneNo ');
};

final PhoneVerificationFailed veriFailed = (AuthException exception) {
  print("verified failed for: $phoneNo ");
  print(exception.message.toString());
  Fluttertoast.showToast(
    msg: "PhoneNumber is not valid!!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 5,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  print("verified failed test done");
};

Future<bool> verifyPhone(BuildContext context) async {
  phoneNo = countryCode + organiserPhoneController.text;
  print("Phone Number is: $phoneNo");
  contextHere = context;
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed,
    );
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> resendOtp(BuildContext context) async {
  // phoneNo = countryCode + organiserPhoneController.text;
  print("resendOtp Phone Number is: $phoneNo");
  contextHere = context;

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNo,
    timeout: const Duration(seconds: 60),
    verificationCompleted: verifiedSuccess,
    verificationFailed: veriFailed,
    codeSent: smsCodeSent,
    forceResendingToken: resendCode,
    codeAutoRetrievalTimeout: autoRetrieve,
  );
}
