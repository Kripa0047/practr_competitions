import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/connection.dart';
import 'package:practrCompetitions/database/getTeamData.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:practrCompetitions/login/phone/OrgPhone.dart';
import 'package:practrCompetitions/screens/Organiser/home.dart';

import 'OrganiserLoginScreens.dart';

String uid;
checkUser() async {
  try {
    var user = await FirebaseAuth.instance.currentUser();
    if (user?.uid == null) return false;
    uid = user.uid;
    organiserId = uid;
    print("user in checkUser0000000000000000000000000000000000000000: $user");
    // DataSnapshot _database = await FirebaseDatabase.instance
    //     .reference()
    //     .child('organiser/$uid')
    //     .once();

    // if (_database.value != null) {
    //   // print("000000  ${_database.key}");
    //   // print("0000001 ${_database.value}");
    // return true;
    // }
    // return false;

    return true;
  } catch (e) {
    print("error in checkUser: $e");
    return false;
  }
}

checkCompetetion() async {
  print("checking competition");
  try {
    uid = organiserId;
    if ((uid == null) || (uid == "")) {
      await checkUser();
    }
    print("checking competition2: $uid");
    bool internetStatus = await connectivityResultFunction();
    if (internetStatus) {
      DataSnapshot _database = await FirebaseDatabase.instance
          .reference()
          .child('competetion')
          .orderByChild('organiserId')
          .equalTo(uid)
          .once();

      // print("checking competition3: $uid");

      // print("checking ${_database.value}");
      if (_database.value != null) {
        checkOrgCompetition = true;
        // print("000000organiserId  ${_database.key}");
        // print("0000001organiserId ahh ${_database.value}");
        var data = _database.value;
        Iterable<dynamic> keyHere = data?.keys;
        List<String> keys =
            keyHere?.map((key) => key.toString())?.toList() ?? List();
        bool returnValue = false;
        for (int i = 0; i < (keys?.length ?? 0); i++) {
          // print('key: ${keys[i]}\nongoing: ${data[keys[0]]['ongoing']}');
          if (data[keys[i]]['ongoing']) {
            returnValue = true;
            orgCompetetionId = data[keys[i]]["id"];
            orgCompetetionName = data[keys[i]]["name"];
            linkLive = data[keys[i]]["LinkLive"];
            // print("orgCompetetionId  $orgCompetetionId");
            // print("orgCompetetionName $orgCompetetionName");
          }
        }

        return returnValue;
      }
      return false;
    }
    return false;
  } catch (e) {
    print("error in checkCompetetion is: $e");
    return false;
  }
}

Future<bool> loginOrg(BuildContext context) async {
  print("we are in loginOrg11111111111111111111111111111");
  bool orgPresent = false;
  orgPresent = await getOrgPresent();
  orgPresent = orgPresent ?? false;
  return orgPresent;
}

submitOrg(bool orgPresent, BuildContext context) async {
  print("we are in submitOrg0000000000000000000000000000");

  bool userPresent = false;
  bool competetionOngoing = false;

  /// case1:  if orgpresent means user has logged in before then it will check for its data saved in
  ///         sharedPreferences if not found then move database.
  /// case2:  if !orgPresent then user when logged in first check data in sharedPreferences(problem:
  ///         user logged in from another device and created commpetition) if not found
  ///         then move to database
  /// **NOTE**: data in sharedPreferences:
  ///             1.Saved:   i). when check from database
  ///                        ii).When competition is created
  ///             2.Removed: i). when user is conclude screen
  ///                        ii)*.(NOT done wright now) When user log out. because at logout orgPresent is false.

  if (orgPresent) {
    List<String> orgData = await getOrgData();
    print("get data from sharedpreferences");
    if (orgData[1] != null) {
      organiserId = orgData[0];
      orgCompetetionId = orgData[1];
      orgCompetetionName = orgData[2];

      userPresent = true;
      competetionOngoing = true;
    } else {
      orgPresent = false;
    }
  }
  if (!orgPresent) {
    userPresent = await checkUser();
    print('userpresent: $userPresent');
    if (userPresent) {
      List<String> orgData = await getOrgData();
      print("get data from sharedpreferences $orgData");
      if (orgData[1] != null) {
        organiserId = orgData[0];
        orgCompetetionId = orgData[1];
        orgCompetetionName = orgData[2];

        competetionOngoing = true;
      } else {
        competetionOngoing = await checkCompetetion();
      }
    }
    await saveOrgData(
      organiserId,
      orgCompetetionId,
      orgCompetetionName,
    );
  }
  // print(
  //     "orgCompetetionId: $orgCompetetionId, orgCompetetionName: $orgCompetetionName");
  // setState(() {
  //   _isLoading = false;
  // });
  // print(
  //     "competetion on going: $competetionOngoing\nuserPresent: $userPresent context is: $context");
  userPresent
      ? competetionOngoing
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => OrganiserHome(),
              ),
              (Route<dynamic> route) => false,
            )
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CompetitionName(),
              ),
              (Route<dynamic> route) => false,
            )
      : Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganiserPhone(),
          ),
        );

  // notify(false);
}
