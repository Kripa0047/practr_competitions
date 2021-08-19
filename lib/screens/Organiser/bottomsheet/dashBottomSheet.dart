import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:practrCompetitions/screens/Organiser/bottomsheet/inviteParticipants.dart';
import 'package:practrCompetitions/screens/Organiser/share/checkPayment.dart';
import 'package:practrCompetitions/screens/Organiser/share/shareMasterSheet.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:page_transition/page_transition.dart';

import 'concludeScreen.dart';

showOptionBottomSheet(
  context,
  shareAvailable,
  particiList,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Color(0xFF737373),
          border: Border.all(color: Color(0xFF737373)),
        ),
        // color: Colors.transparent,
        // height: 180,
        child: Container(
          child: sheetItem(context, shareAvailable, particiList),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            // color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25),
              topRight: const Radius.circular(25),
            ),
          ),
        ),
      );
    },
  );
}

sheetItem(
  context,
  shareAvailable,
  particiList,
) {
  return Wrap(
    children: <Widget>[
      Container(
        height: 8,
      ),
      // ListTile(
      //   // leading: new Icon(Icons.music_note),
      //   onTap: () {
      //     print("Inviting for participants.");

      //     // Navigator.of(context).push(
      //     //   MaterialPageRoute(
      //     //     builder: (context) => InviteParticipants(),
      //     //   ),
      //     // );
      //     Navigator.push(
      //       context,
      //       PageTransition(
      //         type: PageTransitionType.bottomToTop,
      //         child: InviteParticipants(particiList: particiList),
      //       ),
      //     );
      //   },
      //   leading: Icon(
      //     Icons.group_add,
      //     color: primaryColor,
      //   ),
      //   title: new Text(
      //     'Invite Participants',
      //     style: TextStyle(
      //       color: primaryColor,
      //     ),
      //   ),
      // ),
      MasterScoreSheet(
        shareAvailable: shareAvailable,
      ),
      ListTile(
        // leading: new Icon(Icons.music_note),
        onTap: () {
          print("Competetion Concluded");

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConcludeScreen(),
            ),
          );
        },
        leading: Icon(
          FontAwesomeIcons.hourglassEnd,
          color: primaryColor,
        ),
        title: new Text(
          'Conclude Competetion',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      ListTile(
        onTap: () async {
          print("Logged Out");

          await saveOrgPresent(false);

          await FirebaseAuth.instance.signOut().then((action) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/main',
              (Route<dynamic> route) => false,
            );
          }).catchError((e) {
            // print(e);
          });
        },
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.red,
        ),
        title: new Text(
          'Log out',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    ],
  );
}

class MasterScoreSheet extends StatefulWidget {
  var shareAvailable;
  MasterScoreSheet({this.shareAvailable});
  @override
  _MasterScoreSheetState createState() => _MasterScoreSheetState();
}

class _MasterScoreSheetState extends State<MasterScoreSheet> {
  bool _sharing = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: new Icon(Icons.music_note),
      onTap:
          //  widget.shareAvailable
          //     ? () => {}
          //     :
          () async {
        print("Sharing master score sheet");
        setState(() {
          _sharing = true;
        });
        bool paid = false;
        paid = await checkPayment(context);
        if (paid) {
          await shareMasterSheet();
        }
        setState(() {
          _sharing = false;
        });
      },
      leading: _sharing
          ? CircularProgressIndicator()
          : Icon(
              Icons.share,
              color: primaryColor,
            ),
      title: new Text(
        'Share Master Score Sheet',
        style: TextStyle(
          color: primaryColor,
        ),
      ),
    );
  }
}
