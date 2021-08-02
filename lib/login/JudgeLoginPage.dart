import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/login/function.dart';
import 'package:practrCompetitions/modals/scoreModal.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:practrCompetitions/utils/widgets.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'gooey_edge/content_card.dart';
import 'gooey_edge/gooey_carousel.dart';

class JudgeLoginPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          LoginElements(
            height: cHeight,
            scaffoldKey: scaffoldKey,
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Padding(
          //     padding: EdgeInsets.only(top: 100),
          //     child: Container(
          //       // color: Colors.greenAccent,
          //       child: Image.asset(
          //         "assets/u25_logo_white.png",
          //         height: 100,
          //         width: 100,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class LoginElements extends StatefulWidget {
  LoginElements({
    Key key,
    @required this.height,
    @required this.scaffoldKey,
  }) : super(key: key);

  final double height;
  final scaffoldKey;

  @override
  _LoginElementsState createState() => _LoginElementsState();
}

class _LoginElementsState extends State<LoginElements> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // checkLogin();
    // this.initDynamicLinks();
  }

  checkLogin() async {
    setState(() {
      _isLoading = true;
    });
    bool _present = await loginOrg(
      context,
    );
    if (_present) {
      await submitOrg(
        _present,
        context,
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
  // void initDynamicLinks() async {
  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link;

  //   if (deepLink != null) {
  //     print("path of deeplink ${deepLink.path}");
  //     Navigator.pushNamed(context, '/main');
  //     // Navigator.pushNamed(context, deepLink.path);
  //   }

  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     final Uri deepLink = dynamicLink?.link;

  //     if (deepLink != null) {
  //       Navigator.pushNamed(context, deepLink.path);
  //     }
  //   }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return
        // judgeLoginItem();
        // _isLoading
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     :
        gooeyJudgeItem();
  }

  gooeyJudgeItem() {
    return Container(
      child: GooeyCarousel(
        children: <Widget>[
          ContentCard(
            color: 'Red',
            altColor: primaryColor,
            title: helloText1,
            submitOrg: () => submitOrg(
              false,
              context,
            ),
          ),
          ContentCard(
            color: 'Yellow',
            altColor: Colors.pink,
            title: helloText2,
            submitOrg: () => submitOrg(
              false,
              context,
            ),
          ),
          ContentCard(
            color: 'Blue',
            altColor: Colors.yellow,
            title: helloText3,
            submitOrg: () => submitOrg(
              false,
              context,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final Function onPressed;
  final Color color;

  LoginButton({
    @required this.icon,
    @required this.buttonText,
    @required this.onPressed,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton.icon(
            color: color,
            label: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 20,
                  color: color == Colors.yellow ? primaryColor : Colors.white,
                ),
              ),
            ),
            icon: Icon(
              icon,
              color: color == Colors.yellow ? primaryColor : Colors.white,
            ),
            onPressed: onPressed,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
          ),
        ),
      ],
    );
  }
}

class CurvedContainer extends StatelessWidget {
  final double height;
  final double opacity;
  final Widget child;
  final Color color;

  CurvedContainer({this.height, this.child, this.opacity, this.color});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        child: child,
      ),
    );
  }
}

final TextEditingController nameController = TextEditingController();

class JudgeName extends StatefulWidget {
  @override
  _JudgeNameState createState() => _JudgeNameState();
}

class _JudgeNameState extends State<JudgeName> {
  @override
  void initState() {
    super.initState();
    nameController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleFieldForm(
      title: enterJudgeName,
      hintText: "Name",
      labelText: "name",
      routerString: "teamList",
      bottomWidget: Container(),
      inputLeadingWidget: Container(),
      controller: nameController,
      name: true,
      pushNamedAndRemoveUntil: true,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}

final TextEditingController secretCodeController = TextEditingController();
var dataContest;

class JudgeOTP extends StatefulWidget {
  @override
  _JudgeOTPState createState() => _JudgeOTPState();
}

class _JudgeOTPState extends State<JudgeOTP> {
  @override
  void initState() {
    super.initState();
    secretCodeController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    // secretCodeController?.clear();
    return SingleFieldForm(
      pushNamedAndRemoveUntil: true,
      title: enterSecretCode,
      labelText: "secret code is case sensitive",
      routerString: "judgeName",
      bottomWidget: Container(),
      inputLeadingWidget: Container(),
      controller: secretCodeController,
      secretCode: true,
      // textCapitalization: TextCapitalization.characters,
      keyBoardType: TextInputType.visiblePassword,
    );
  }
}

class ConfirmSubmission extends StatelessWidget {
  final TextEditingController submissionController = TextEditingController();

  final ScoreModal modal;

  ConfirmSubmission({
    @required this.modal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleFieldForm(
      // pushNamedAndRemoveUntil: true,
      title: "Ready to submit?",
      labelText: "Type SUBMIT to confirm",
      hintText: "SUBMIT",
      bottomWidget: Container(),
      inputLeadingWidget: Container(),
      btnText: "Confirm Submission",
      routerString: "",
      textCapitalization: TextCapitalization.characters,
      controller: submissionController,
      confirm: true,
      pushNamedAndRemoveUntil: true,
      scoreModal: modal,
    );
  }
}
