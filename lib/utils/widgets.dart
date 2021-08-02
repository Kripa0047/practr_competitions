import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/function.dart';
import 'package:practrCompetitions/database/getTeamData.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:practrCompetitions/modals/scoreModal.dart';
import 'package:practrCompetitions/resources/api/checkJudge.dart';
import 'package:practrCompetitions/resources/api/createCompetetion.dart';
import 'package:practrCompetitions/resources/api/createOrganiser.dart';
import 'package:practrCompetitions/resources/api/createParticipantApi.dart';
import 'package:practrCompetitions/resources/api/getOldJudge.dart';
import 'package:practrCompetitions/resources/api/getTaskApi.dart';
import 'package:practrCompetitions/resources/api/uploadScoreApi.dart';
import 'package:practrCompetitions/utils/progressIndicator.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

var nameHere;
var secretCodeHere;

class SingleFieldForm extends StatefulWidget {
  final String title;
  final String topTitle;
  final String topSubTitle;
  final String hintText;
  final String btnText;
  String routerString;
  final String labelText;
  final bool obscureText;
  final TextInputType keyBoardType;
  final bool pushNamedAndRemoveUntil;
  final Widget bottomWidget;
  final Widget inputLeadingWidget;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  bool confirm;
  bool name;
  bool secretCode;
  ScoreModal scoreModal;
  final String prefixText;
  final GlobalKey<FormState> formKey;
  Function onPressed;
  String type;
  BuildContext context;
  bool autofocus;
  var dataForm;

  SingleFieldForm({
    this.autofocus = true,
    this.btnText = "SUBMIT",
    this.hintText,
    this.title,
    this.labelText,
    this.topTitle = "",
    this.topSubTitle = "",
    this.obscureText = false,
    this.pushNamedAndRemoveUntil = false,
    this.routerString,
    this.bottomWidget,
    this.inputLeadingWidget,
    this.keyBoardType = TextInputType.text,
    this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.confirm = false,
    this.name = false,
    this.secretCode = false,
    this.scoreModal,
    this.prefixText = '',
    this.formKey,
    this.onPressed,
    this.type,
    this.context,
    this.dataForm,
  });

  @override
  _SingleFieldFormState createState() => _SingleFieldFormState();
}

class _SingleFieldFormState extends State<SingleFieldForm> {
  bool show = false;
  bool go = true;
  bool delete = false;
  bool conclude = true;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  checkConfirm() {
    if (widget.confirm) {
      if (mounted) {
        String text = widget.controller.text
            .toUpperCase()
            .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        if (text == 'SUBMIT') {
          setState(() {
            show = true;
          });
        } else if (text == 'DELETE') {
          setState(() {
            show = true;
          });
          delete = true;
        } else {
          setState(() {
            show = false;
          });
        }
      }

      // print("controller value: ${widget.controller.text}");
    } else if (widget.name) {
      print("show name $show");
      if (widget.controller.text != '') {
        setState(() {
          show = true;
          nameHere = widget.controller.text;
        });
      } else {
        setState(() {
          show = false;
        });
      }
    } else if (widget.secretCode) {
      if (widget.controller.text != '') {
        setState(() {
          show = true;
          secretCodeHere = widget.controller.text;
        });
      } else {
        setState(() {
          show = false;
        });
      }
    } else if (widget.type == 'conclude') {
      if (mounted) {
        String text = widget.controller.text
            .toUpperCase()
            .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        if (text == 'CONCLUDE') {
          setState(() {
            show = true;
          });
        } else {
          setState(() {
            show = false;
          });
        }
      }

      // print("controller value: ${widget.controller.text}");
    } else {
      if (widget.controller.text != '') {
        setState(() {
          show = true;
        });
      } else {
        setState(() {
          show = false;
        });
      }
    }
  }

  bool _isLoading = false;

  Future<void> checkFunction(BuildContext contextHere) async {
    setState(() {
      _isLoading = true;
    });
    if (widget.secretCode) {
      print("secret code go check");

      secretCodeJudge = widget.controller.text;

      String uDeviceId = await getDeviceId();
      judgeUDeviceId = uDeviceId;
      bool _success = await getTask(
        context,
        widget.controller.text,
        _scaffoldKey,
      );

      bool _getOldJudge = false;

      List<String> judgeData = await getJudgeNameData();

      if (judgeData[0] != null) {
        _getOldJudge = true;

        judgeName = judgeData[0];
        judgeUniqueId = judgeData[1];
        judgeKey = judgeData[2];
      }
      setState(() {
        _isLoading = false;
      });

      go = true;

      if (_success == false || _success == null) {
        go = false;
      } else {
        go = true;
        print("getOldJudge: $_getOldJudge");
        if (_getOldJudge) {
          widget.routerString = "teamList";
        }
      }
    } else if (widget.name) {
      print("name check");
      String uDeviceId = judgeUDeviceId;
      judgeName = widget.controller.text
          .toUpperCase()
          .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      go = await checkJudgeExist(
        context,
        judgeName,
        secretCodeJudge,
        uDeviceId,
        _scaffoldKey,
      );
      setState(() {
        _isLoading = false;
      });
      print("name will move $go");
    } else if (widget.confirm) {
      // also save data to database
      // go = true to move to main page

      if (delete) {
        try {
          await FirebaseDatabase.instance
              .reference()
              .child('judges/$judgeKey')
              .remove();
          go = true;
        } catch (e) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Error Occured!$e",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ));
          go = false;
        }
      } else {
        go = await uploadScore(
          context,
          widget.scoreModal,
          _scaffoldKey,
        );
      }
      setState(() {
        _isLoading = false;
      });
      if (go) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences?.remove('judgeNameS');
        preferences?.remove('judgeUniqueIdS');
        preferences?.remove('judgeKeyS');
      }
    } else if (widget.type == 'comp') {
      go = await createCompetetion(
        context,
        widget.controller.text,
        organiserId,
        _scaffoldKey,
      );
      setState(() {
        _isLoading = false;
      });
    } else if (widget.type == 'org') {
      go = await createOrganiser(
        context,
        widget.controller.text,
        _scaffoldKey,
      );
      setState(() {
        _isLoading = false;
      });
    } else if (widget.type == 'partici') {
      go = false;
      bool _return = await createParticipant(
        context,
        widget.dataForm,
        widget.controller.text,
      );
      if (_return) {
        widget.controller?.clear();
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // print("show $show");
    show = false;
  }

  refresh() {
    checkConfirm();
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
        actions: <Widget>[
          widget.type == 'comp'
              ? IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: primaryColor,
                  ),
                  onPressed: () async {
                    print("Logged Out");
                    await saveOrgPresent(false);
                    await FirebaseAuth.instance.signOut().then((action) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/main',
                        (Route<dynamic> route) => false,
                      );
                    }).catchError((e) {
                      // print(e);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/main',
                        (Route<dynamic> route) => false,
                      );
//                errorDialog(
//                  context,
//                  'Try Again',
//                  'Unable to Log out',
//                );
                    });
                  },
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Container(
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
//                Container(
//                  height: _height / 20,
//                ),
                Text(
                  widget.topTitle,
                  style: kSecondaryTextStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w300),
                ),
                Text(
                  widget.topSubTitle,
                  style: kSecondaryTextStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.title,
                  style: kPrimaryTextStyle.copyWith(
                      fontSize: cWidth * 0.08, height: 1.2),
                ),
                SizedBox(
                  height: cHeight * 0.02,
                ),
                Row(
                  children: <Widget>[
                    widget.inputLeadingWidget,
                    Expanded(
                      child: AppTextField(
                        keyboardType: widget.keyBoardType,
                        obscureText: widget.obscureText,
                        labelText: widget.labelText,
                        hintText: widget.hintText,
                        controller: widget.controller,
                        textCapitalization: widget.textCapitalization,
                        notify: refresh,
                        confirm: true,
                        formKey: widget.formKey,
                        prefixText: widget.prefixText,
                        autofocus: widget.autofocus,
                        // widget.confirm || widget.name || widget.secretCode,
                      ),
                    ),
                  ],
                ),
                !widget.confirm
                    ? Container()
                    : SizedBox(
                        height: cHeight * 0.02,
                      ),
                !widget.confirm
                    ? Container()
                    : RichText(
                        text: TextSpan(
                          text: 'Or type ',
                          style: kSecondaryTextStyle,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'DELETE',
                              style: kPrimaryTextStyle.copyWith(
                                color: CupertinoColors.destructiveRed,
                              ),
                            ),
                            TextSpan(
                              text: ' to delete this session.',
                            ),
                          ],
                        ),
                      ),
                // Text(
                //   'Or type DELETE to delete this session.',
                //   style: kSecondaryTextStyle,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 26.0),
                //   child: widget.bottomWidget,
                // ),
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
                            onPressed: !show
                                ? null
                                : () async {
                                    print("onpressssssssssssss");
                                    await checkFunction(context);
                                    !go
                                        ? null
                                        : {
                                            if (widget.type == "partici")
                                              {Navigator.pop(widget.context)}
                                            else
                                              {
                                                widget.onPressed != null
                                                    ? widget.onPressed()
                                                    : widget
                                                            .pushNamedAndRemoveUntil
                                                        ? Navigator
                                                            .pushNamedAndRemoveUntil(
                                                                context,
                                                                "/" +
                                                                    widget
                                                                        .routerString,
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false)
                                                        : Navigator.pushNamed(
                                                            context,
                                                            "/" +
                                                                widget
                                                                    .routerString)
                                              }
                                          };
                                  },
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
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  final int maxlines;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  Function notify;
  bool confirm = false;
  final String prefixText;
  GlobalKey<FormState> formKey;

  bool autofocus;

  AppTextField({
    this.autofocus = true,
    this.maxlines = 1,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.textCapitalization = TextCapitalization.sentences,
    this.notify,
    this.confirm,
    this.prefixText,
    this.formKey,
  });

  checkConfirm() {
    if (confirm ?? false)
      controller.addListener(() {
        notify();

        // print("controller value3: ${controller.text}");
      });
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
      child: Form(
        key: formKey,
        child: TextField(
          textCapitalization: textCapitalization,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          autofocus: autofocus,
          style: TextStyle(fontSize: 20),
          maxLines: maxlines,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixText: prefixText,
            hintText: hintText,
            contentPadding: EdgeInsets.all(20),
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}

Widget buildSheetAddNote(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double keyboardClosed = MediaQuery.of(context).viewInsets.bottom;
//  double width = MediaQuery.of(context).size.width;
  return ClipRRect(
    borderRadius: new BorderRadius.vertical(top: const Radius.circular(30.0)),
    child: Container(
      height: height / 3,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius:
            new BorderRadius.vertical(top: const Radius.circular(30.0)),
      ),
      child: UploadOptions(),
    ),
  );
}

class UploadOptions extends StatelessWidget {
  const UploadOptions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton.icon(
                      label: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Upload files",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      icon: Icon(
                        Icons.file_upload,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            "/JudgeProfile", (Route<dynamic> route) => false);
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton.icon(
                      label: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Submit from Desktop",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      icon: Icon(
                        Icons.computer,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            "/JudgeProfile", (Route<dynamic> route) => false);
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: FlatButton.icon(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    label: Text("close")),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class UploadFromPhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("1"),
      ),
    );
  }
}
