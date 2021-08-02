import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:practrCompetitions/login/otpVerify.dart' as otpVerify;
import 'package:practrCompetitions/login/phone/OrgPhone.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:practrCompetitions/Lang/English.dart';

final TextEditingController organiserOTPController = TextEditingController();

class OrganiserOTP extends StatefulWidget {
  @override
  _OrganisationPhoneState createState() => _OrganisationPhoneState();
}

class _OrganisationPhoneState extends State<OrganiserOTP> {
  @override
  void initState() {
    super.initState();
    organiserOTPController?.clear();

    startTime = cTime;
    endTime = cTime.add(Duration(seconds: 15));

    alert = DateTime.now().add(Duration(seconds: 15));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  DateTime cTime = DateTime.now();
  DateTime startTime;
  DateTime endTime;

  DateTime alert;

  String formatDuration(Duration d) {
    String f(int n) {
      return n.toString().padLeft(2, '0');
    }

    // We want to round up the remaining time to the nearest second
    d += Duration(microseconds: 999999);
    return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleFieldFormOtp(
      title: enterOTP,
      // hintText: "****",
      labelText: "OTP",
      bottomWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Haven't recieved OTP? ",
            style: kSecondaryTextStyle.copyWith(
              fontSize: cWidth * 0.042,
            ),
          ),
          TimerBuilder.scheduled(
            [alert],
            builder: (context) {
              // This function will be called once the alert time is reached
              var now = DateTime.now();
              bool reached = now.compareTo(alert) >= 0;
              final textStyle = Theme.of(context).textTheme.title;
              return Center(
                child: Row(
                  children: <Widget>[
                    !reached
                        ? TimerBuilder.periodic(Duration(seconds: 1),
                            alignment: Duration.zero, builder: (context) {
                            // This function will be called every second until the alert time
                            var now = DateTime.now();
                            var remaining = alert.difference(now);
                            return Text(
                              formatDuration(remaining),
                              style: textStyle.copyWith(
                                fontSize: cWidth * 0.042,
                              ),
                            );
                          })
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                        onTap: !reached
                            ? null
                            : () {
                                otpVerify.resendOtp(context);
                                setState(() {
                                  alert =
                                      DateTime.now().add(Duration(seconds: 15));
                                });
                              },
                        child: Text(
                          "Resend Now!",
                          style: kPrimaryTextStyle.copyWith(
                            fontSize: cWidth * 0.046,
                            color: !reached ? Colors.grey : primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      controller: organiserOTPController,
      keyBoardType: TextInputType.number,
      pushNamedAndRemoveUntil: true,
    );
  }
}

class SingleFieldFormOtp extends StatefulWidget {
  final String title;
  final String hintText;
  final String btnText;
  final String labelText;
  final TextInputType keyBoardType;
  final bool pushNamedAndRemoveUntil;
  final TextEditingController controller;
  final String prefixText;
  Function onPressed;
  final Widget bottomWidget;

  SingleFieldFormOtp({
    this.btnText = "SUBMIT",
    this.hintText,
    this.title,
    this.labelText,
    this.pushNamedAndRemoveUntil = false,
    this.keyBoardType = TextInputType.text,
    this.controller,
    this.prefixText = '',
    this.onPressed,
    this.bottomWidget,
  });

  @override
  _SingleFieldFormState createState() => _SingleFieldFormState();
}

class _SingleFieldFormState extends State<SingleFieldFormOtp> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  submitPressed() {
    setState(() {
      _isLoading = true;
    });
    DatabaseReference _database;
    var uid;
    FirebaseAuth.instance.currentUser().then(
      (user) async {
        print("userOtpbutton $user");

        final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: otpVerify.verificationId,
          smsCode: otpVerify.smsCode,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((user2) async {
          organiserPhoneController.text = "";
          // print("user2 is: $user2");
          // var path = "/orgName";
          var path = '/compName';
          if (user2 != null) {
            uid = user2.user.uid;

            organiserId = uid;
            await saveOrgPresent(true);
            // FirebaseMessaging _messaging = FirebaseMessaging();
            // // var _fcmToken;
            // _messaging.subscribeToTopic(uid).catchError((e) {
            //   // // print("errrrrrrrrrrrrrrr $e");
            // });
            _database =
                FirebaseDatabase.instance.reference().child('organiser');
            // await _database.child(uid).once().then((DataSnapshot data) {
            //   print("000000 ${data.key}");
            //   print("0000001 ${data.value}");
            //   if (data.value != null) {
            //     path = "/compName";
            //     organiserId = data.value['id'];
            //   }
            // });
            await FirebaseDatabase.instance
                .reference()
                .child('competetion')
                .orderByChild('organiserId')
                .equalTo(uid)
                .once()
                .then((DataSnapshot data) {
              print("000002 ${data.key}");
              print("000003 ${data.value}");
              if (data.value != null) {
                // Map<String, dynamic> r = data.value;
//                for (var item in data.value) {
//                  print("key: ${item.key}");
//                  print("value: ${item.value}");
//
//                  orgCompetetionName = item.value['name'];
//                  orgCompetetionId = item.key;
//                  if (item.value['ongoing']) {
//                    path = "/orgHome";
//                  }
//                }
                data.value.forEach((key, value) {
                  print("key: $key");
                  print("value: $value");

                  if (value['ongoing']) {
                    orgCompetetionName = value['name'];
                    orgCompetetionId = key;
                    linkLive = value["LinkLive"];

                    path = "/orgHome";
                  }
                  print('orgCompetetionName in submit: $orgCompetetionName');
                });
              }
            });
          }
          otpVerify.smsCode = "";
          // setState(() {
          //   _isLoading = true;
          // });
          print("path is: $path");
          Navigator.of(context).pushNamedAndRemoveUntil(
            path,
            (Route<dynamic> route) => false,
          );
        }).catchError((e) {
          setState(() {
            _isLoading = false;
          });
          print(e);
          return errorDialog(
            context,
            "Try Again!!",
            "Please enter a correct OTP!",
          );
        });
      },
    );
  }

  bool show = false;
  checkConfirm() {
    if (widget.controller.text != '') {
      setState(() {
        show = true;
      });
      otpVerify.smsCode = widget.controller.text;
    } else {
      setState(() {
        show = false;
      });
    }
  }

  bool _isLoading = false;

  Future<void> checkFunction() async {
    setState(() {
      _isLoading = true;
    });
    // if()
  }

  @override
  void initState() {
    super.initState();
    print("show $show");
    show = false;
  }

  refresh() {
    checkConfirm();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: _height / 20,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.title,
                style: kPrimaryTextStyle.copyWith(fontSize: 35, height: 1.2),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppTextField2(
                      enabled: !_isLoading,
                      keyboardType: widget.keyBoardType,
                      labelText: widget.labelText,
                      hintText: widget.hintText,
                      controller: widget.controller,
                      notify: refresh,
                      confirm: true,
                      prefixText: widget.prefixText,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: widget.bottomWidget,
              ),
              Spacer(),
              _isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.btnText,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: !show ? null : () => submitPressed(),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTextField2 extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  Function notify;
  bool confirm = false;
  final String prefixText;
  bool enabled;

  AppTextField2({
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.textCapitalization = TextCapitalization.sentences,
    this.notify,
    this.confirm,
    this.prefixText,
    this.enabled = true,
  });

  checkConfirm() {
    if (confirm ?? false) {
      controller.addListener(() {
        notify();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkConfirm();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextField(
        textCapitalization: textCapitalization,
        autofocus: true,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          enabled: enabled,
          prefixText: prefixText,
          hintText: hintText,
          contentPadding: EdgeInsets.all(20),
          labelText: labelText,
        ),
      ),
    );
  }
}
