import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/login/function.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen> {
  var _visible = true;

  bool _isLoading = false;

  notify(bool value) {
    print("notify is called:");
    // setState(() {
    _isLoading = value;
    if (value) {
      startTime();
    }
    // });
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/main');
  }

  @override
  void initState() {
    super.initState();
    print("000000000000000000we are in splash screen");
    setState(() {
      _visible = !_visible;
    });
    // startTime();
    checkLogin();
    // this.initDynamicLinks();
  }

  checkLogin() async {
    bool _present = await loginOrg(context);
    if (_present) {
      await submitOrg(
        _present,
        context,
      );
    } else {
      startTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
