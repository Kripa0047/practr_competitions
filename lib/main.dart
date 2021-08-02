// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practrCompetitions/login/splashScreen.dart';
import 'login/JudgeLoginPage.dart';
import 'screens/Judge/dash.dart';
import 'screens/Judge/firebase_mesg.dart';
// import 'package:judge/screens/Organiser/participant/participants.dart';
import 'screens/Organiser/round/createRound.dart';
import 'utils/styles.dart';
import 'common/common.dart';
import 'login/OrganiserLoginScreens.dart';
import 'login/phone/OrgOtp.dart';
import 'login/phone/OrgPhone.dart';
import 'screens/Organiser/home.dart';

import 'login/JudgeLoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    organiserPhoneController?.clear();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      routes: {
        '/main': (context) => JudgeLoginPage(),
        "/judgeName": (context) => JudgeName(),
        '/teamList': (context) => JudgeDash(),
        '/orgHome': (context) => OrganiserHome(),
        '/orgName': (context) => OrganiserName(),
        '/orgPhone': (context) => OrganiserPhone(),
        '/orgOTP': (context) => OrganiserOTP(),
        // '/orgDash': (context) => OrganiserDashboard(),
        '/compName': (context) => CompetitionName(),
        // '/createRound': (context) => CreateRound(),
        // '/enterParticipantCode': (context) => EnterParticipantCode(),
        // '/roundDetails': (context) => RoundDetails(),
        // '/enterCriteria': (context) => EnterCriteria(
        //   controller: CreateRound.,
        // ),
      },
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: primaryColor,
        sliderTheme: SliderTheme.of(context).copyWith(
          inactiveTrackColor: Colors.grey,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
          thumbColor: Color(0xFFEB1555),
          activeTrackColor: Colors.pink,
          overlayColor: Color(0x29EB1555),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        fontFamily: 'GilroyLight',
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: primaryColor,
        ),
        cursorColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.pink),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(21),
            ),
            borderSide: BorderSide(
              color: Color(0xFF382176),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(21),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xFF382176),
          elevation: 0,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF382176),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20.0),
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home:
          // AnimatedSplashScreen(),
          ScrollConfiguration(
        behavior: BounceScrollBehavior(),
        child: StartApp(),
      ),
    );
  }
}

class BounceScrollBehavior extends ScrollBehavior {
  @override
  getScrollPhysics(_) => const BouncingScrollPhysics();
}

class StartApp extends StatefulWidget {
  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  void initState() {
    super.initState();

    FirebaseNotifications().setUpFirebase();
    _getRemoteVariable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _getRemoteVariable() async {
    // try {
    //   final RemoteConfig remoteConfig = await RemoteConfig.instance;
    //   final defaults = <String, dynamic>{
    //     'razorpay_enabled': false,
    //   };
    //   await remoteConfig.setDefaultsAsync(defaults);
    //   await remoteConfig.fetch(expiration: const Duration(minutes: 1));
    //   await remoteConfig.activateFetched();
    //   razorpay_enabled = remoteConfig.getBool('razorpay_enabled');
    // } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return AnimatedSplashScreen();
    // JudgeLoginPage();
  }
}
