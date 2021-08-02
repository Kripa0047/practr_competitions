import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/utils/styles.dart';

emptyLiveJudge() {
  return Container(
    // height: cHeight * 0.35,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      // color: Colors.red,
    ),
    child: Column(
      children: <Widget>[
        Center(
          child: SvgPicture.asset(
            'assets/InviteJudges.svg',
            fit: BoxFit.cover,

            // height: cHeight,
            width: cWidth * 0.7,
          ),
        ),
        Container(
          height: cHeight * 0.04,
        ),
        Text(
          judgesEmptyState,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cWidth * 0.06,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

emptyDraftJudge() {
  /// this is responsible for draft image at last to be not rounded
  return Container(
    // height: cHeight * 0.3,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      // color: Colors.green,
    ),
    child: Column(
      children: <Widget>[
        Center(
          child: SvgPicture.asset(
            'assets/draft.svg',
            alignment: Alignment.center,
            fit: BoxFit.cover,
            width: cWidth * 0.7,
            // width: cWidth,
          ),
        ),
        Container(
          height: cHeight * 0.04,
        ),
        Text(
          draftState,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cWidth * 0.06,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget emptyRound() {
  return Container(
    // height: cHeight * 0.6,
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Center(
          child: SvgPicture.asset(
            'assets/noRounds.svg',
            fit: BoxFit.cover,
            // height: cHeight,
            width: cWidth,
          ),
        ),
        // Container(
        //   // height: cHeight * 0.04,
        // ),
        Text(
          roundsEmptyState,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cWidth * 0.06,
            color: primaryColor,
          ),
        ),
      ],
    ),
  );
}

Widget emptyPartici() {
  return Container(
    padding: EdgeInsets.all(8),
    width: cWidth,
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Container(
          height: cHeight * 0.04,
        ),
        Center(
          child: SvgPicture.asset(
            'assets/participantsList.svg',
            fit: BoxFit.cover,
            // height: cHeight * 0.,
            width: cWidth,
          ),
        ),
        Container(
          height: cHeight * 0.04,
        ),
        Text(
          participantsEmptyState,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cWidth * 0.06,
            color: primaryColor,
          ),
        ),
      ],
    ),
  );
}

Widget emptyCriteria() {
  return Container(
    // height: cHeight * 0.44,
    width: cWidth,
    alignment: Alignment.center,
    child: ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Center(
          child: SvgPicture.asset(
            'assets/noCriterias.svg',
            fit: BoxFit.cover,
            // height: cHeight * 0.7,
            width: cWidth,
          ),
        ),
        Container(
          height: cHeight * 0.04,
        ),
        Text(
          criteriaEmptyState,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cWidth * 0.06,
            color: primaryColor,
          ),
        ),
      ],
    ),
  );
}

Widget emptyQualified() {
  return Padding(
    padding: EdgeInsets.only(top: cHeight * 0.082),
    child: Container(
      // height: cHeight * 0.42,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SvgPicture.asset(
              'assets/participantsList.svg',
              fit: BoxFit.cover,
              // height: cHeight,  \
              width: cWidth,
            ),
            Container(
              height: cHeight * 0.04,
            ),
            Text(
              participantsEmptyState,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: cWidth * 0.06,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget emptyDisQualified() {
  return Container(
    padding: EdgeInsets.only(top: cHeight * 0.092),
    child: Container(
      // height: cHeight * 0.42,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          SvgPicture.asset(
            'assets/eliminated.svg',
            fit: BoxFit.cover,
            // height: cHeight,
            width: cWidth,
          ),
          Container(
            height: cHeight * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              eliminatedParticipantsEmptyState,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: cWidth * 0.06,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget emptyInvite() {
  return Container(
    // height: cHeight * 0.42,

    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SvgPicture.asset(
          'assets/participantsList.svg',
          fit: BoxFit.cover,
          // height: cHeight,  \
          width: cWidth,
        ),
        // Container(
        //   height: cHeight * 0.04,
        // ),
        Text(
          inivitationContent,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cWidth * 0.06,
            color: primaryColor,
          ),
        ),
      ],
    ),
  );
}

Widget emptyInternet() {
  return Container(
    // height: cHeight * 0.42,

    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SvgPicture.asset(
          'assets/illustration.svg',
          fit: BoxFit.cover,
          // height: cHeight,  \
          width: cWidth,
        ),
        // Container(
        //   height: cHeight * 0.04,
        // ),
        Text(
          inivitationContent,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: cWidth * 0.06,
            color: primaryColor,
          ),
        ),
      ],
    ),
  );
}
