import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/modals/teamModal.dart';
import 'package:practrCompetitions/screens/Organiser/emptyState/emptyOrg.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'inviteFunc.dart';

class InviteParticipants extends StatefulWidget {
  List<TeamModal> particiList;
  InviteParticipants({
    @required this.particiList,
  });
  @override
  _InviteParticipantsState createState() => _InviteParticipantsState();
}

class _InviteParticipantsState extends State<InviteParticipants> {
  bool _clicked = false;
  int numberPartici = 0;
  bool _value = linkLive;
  String _data = 'https://under25contests.com?id=' + orgCompetetionId;
  GlobalKey globalKey = GlobalKey();

  _launchURL() async {
    if (!_clicked)
      setState(() {
        _clicked = true;
      });
    String url = _data;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  calculateNumberPartici() {
    print('linkLive value: $linkLive');
    int _len = widget.particiList?.length ?? 0;
    for (var j = 0; j < _len; j++) {
      print(
          'calculating points now0000000000000000000000000000000000 ${widget.particiList[j].phoneNo}');
      String phoneNo = widget.particiList[j].phoneNo;
      if (phoneNo != null) {
        numberPartici++;
      }
    }
  }

  Future<bool> updateComp(value) async {
    try {
      var response = await FirebaseDatabase.instance
          .reference()
          .child('competetion/$orgCompetetionId')
          .update({"LinkLive": value});
      print("response is: ");
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateNumberPartici();
  }

  @override
  Widget build(BuildContext context) {
    String partici = 'participants';
    String helpVerb = 'were';
    if (numberPartici == 1) {
      partici = 'participant';
      helpVerb = 'was';
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Invitation link"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  )
                : CupertinoSwitch(
                    activeColor: Colors.pink,
                    value: _value,
                    onChanged: (bool value) async {
                      // print("it i tapp");
                      setState(() {
                        _isLoading = true;
                      });
                      // print("it i 1");
                      bool success = await updateComp(value);
                      // print("it i 2 $success");
                      if (success)
                        setState(() {
                          _value = value;
                          _isLoading = false;
                        });
                      else
                        setState(() {
                          _isLoading = false;
                        });
                    },
                  ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        height: cHeight,
        width: cWidth,
        child: !_value
            ? emptyInvite()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RepaintBoundary(
                    key: globalKey,
                    child: Container(
                      height: cWidth / 1.5,
                      width: cWidth / 1.5,
                      color: Colors.white,
                      child: QrImage(
                        data: _data,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: Container(
                        width: cWidth * 0.9,
                        child: AutoSizeText(
                          _data ??
                              "https://under25competitions.com/register/bhjkbj",
                          style: kPrimaryTextStyle.copyWith(
                            color: _clicked ? Colors.pink[300] : Colors.pink,
                            fontSize: cWidth / 25,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                        onPressed: () {
                          captureAndSharePng(
                            globalKey,
                            _data,
                          );
                        },
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        label: Text(" Share  "),
                      ),
                      SizedBox(
                        width: cWidth * 0.1,
                      ),
                      RaisedButton.icon(
                        onPressed: () {
                          Clipboard.setData(new ClipboardData(text: _data));

                          Fluttertoast.showToast(
                            msg: "Copied to Clipboard",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 5,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        icon: Icon(
                          Icons.content_copy,
                          color: Colors.white,
                        ),
                        label: Text("Copy link"),
                      ),
                    ],
                  ),
                  // Chip(
                  //   label: Text("Link was opened 110 times"),
                  // ),
                  Chip(
                    label: RichText(
                      text: TextSpan(
                          text: '$numberPartici $partici',
                          style: TextStyle(
                            color: Colors.pink,
                            // fontSize: 18,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' $helpVerb added so far.',
                              style: TextStyle(
                                color: Colors.black,
                                // fontSize: 18,
                              ),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
