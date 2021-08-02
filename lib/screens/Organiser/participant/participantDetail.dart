import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/modals/particiSheet.dart';
import 'package:practrCompetitions/modals/roundModal.dart';
import 'package:practrCompetitions/screens/Organiser/share/checkPayment.dart';
import 'package:practrCompetitions/screens/Organiser/share/shareParticipant.dart';
import 'package:practrCompetitions/utils/styles.dart';

class ParticipantDetail extends StatefulWidget {
  var particilist;
  var particiIndex;
  var roundList;
  ParticipantDetail({
    @required this.particilist,
    @required this.particiIndex,
    @required this.roundList,
  });
  @override
  _ParticipantDetailState createState() => _ParticipantDetailState();
}

class _ParticipantDetailState extends State<ParticipantDetail> {
  TextEditingController participantNameController = TextEditingController();
  bool edit = false;
  giveHint() {
    Fluttertoast.showToast(
      msg: "Enter round title",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  List<double> pointList = List();

  calculatePoints() {
    print("pointList length: ${pointList.length}");
    int _rLen = widget.roundList.length;
    double points = 0;
    for (int i = 0; i < _rLen; i++) {
      double _weightage = widget.roundList[i].weightage.toDouble();
      _weightage /= 100;
      String _roundName = widget.roundList[i].name;
      String _roundId = widget.roundList[i].taskId;

      double roundPoint = 0.0;
      int _roundLen = 0;
      widget.particilist[widget.particiIndex]?.data[_roundId]
          ?.forEach((key, value) {
        //also done same in participant.dart
        if (value["qualified"] != null && value["qualified"]) {
          // comment because average not happening when judge not submit data
          _roundLen++;
          roundPoint += value["score"]?.toDouble() ?? 0.0;
        }
      });
      if (roundPoint != 0.0) {
        roundPoint /= _roundLen;
        roundPoint *= _weightage;
        points += roundPoint;
      }
      pointList.add(roundPoint);
      shareList.add(
        ParticiSheet(
          name: _roundName,
          score: roundPoint,
        ),
      );
    }
    print("pointList length: ${pointList.length}");
    shareList.add(
      ParticiSheet(
        name: 'Total',
        score: points,
      ),
    );
    return points;
  }

  List<ParticiSheet> shareList = List();

  updateParticipant() async {
    String pId = widget.particilist[widget.particiIndex].participantId;
    bool uniqueCode = true;

    String text = participantNameController.text
        .toUpperCase()
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String pParticiCode =
        pCode.toUpperCase().replaceAll(new RegExp(r"\s+\b|\b\s"), "");

    if (text == pParticiCode) {
      return;
    } // remove unnecessary check
    for (int i = 0; i < widget.particilist?.length ?? 0; i++) {
      print("particiList is: ${widget.particilist[i].code}");
      String codeHere = widget.particilist[i].code
          .toUpperCase()
          .replaceAll(new RegExp(r"\s+\b|\b\s"), "");

      if (text == codeHere) {
        uniqueCode = false;
        break;
      }
    }
    if (uniqueCode) {
      await FirebaseDatabase.instance
          .reference()
          .child('participants/$orgCompetetionId')
          .child(pId)
          .update({'code': participantNameController.text});

      pCode = participantNameController.text;
    } else {
      errorDialog(
        context,
        'Try Again!!',
        'Participant Code not unique!!',
      );
      participantNameController.text = pCode;
    }
  }

  bool _isDeleting = false;

  deleteParticipant(BuildContext context) async {
    setState(() {
      _isDeleting = true;
    });

    String pId = widget.particilist[widget.particiIndex].participantId;
    await FirebaseDatabase.instance
        .reference()
        .child('participants/$orgCompetetionId')
        .child(pId)
        .remove();
    widget.particilist.removeAt(widget.particiIndex);

    // Navigator.pop(context);
    setState(() {
      _isDeleting = false;
    });

    Navigator.pop(context);
  }

  bool _isQualified = true;
  String pCode;
  var totalPoints = 0.0;
  bool save = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pCode = widget.particilist[widget.particiIndex].code; // participant code
    participantNameController.text = pCode;
    _isQualified = widget.particilist[widget.particiIndex].qualified;
    if (widget.particilist[widget.particiIndex].data != null) {
      totalPoints = calculatePoints();
    }
    participantNameController.addListener(() {
      print(participantNameController.text);
      if (participantNameController.text == '') {
        setState(() {
          save = false;
        });
      } else {
        setState(() {
          save = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  FocusNode myFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    print('value of edit $edit');

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      bottomNavigationBar: bottomAppBar(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: SafeArea(
        bottom: false,
        child: _isDeleting
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                !edit ? EdgeInsets.all(8.0) : EdgeInsets.all(0),
                            child: TextField(
                              enabled:
                                  //  true,
                                  edit,
                              focusNode: myFocusNode,
                              controller: participantNameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                hintText: "Round Title",
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              style: kPrimaryTextStyle.copyWith(
                                fontSize: cWidth / 10,
                                color: edit ? Colors.grey : primaryColor,
                              ),
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: !save
                              ? null
                              : () {
                                  setState(() {
                                    edit = !edit;
                                  });
                                  if (edit == false) {
                                    print(
                                        'myFocusNode edit false: $myFocusNode');
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    // done, grey, text can be edited

                                    updateParticipant();
                                  } else {
                                    FocusScope.of(context)
                                        .requestFocus(myFocusNode);
                                    print(
                                        'myFocusNode edit true: $myFocusNode');
                                  }
                                },
                          child: Text(
                            edit ? 'Done' : 'Edit',
                            style: kPrimaryTextStyle.copyWith(
                              color: !save ? Colors.grey : primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: RoundScore(
                        roundList: widget.roundList,
                        pointList: pointList,
                        totalPoints: totalPoints,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget bottomAppBar() {
    return BottomAppBar(
      color: primaryColor,
      notchMargin: 4.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => confirmDialog(
                context,
                deleteParticipantHeader,
                deleteParticipantBody,
                deleteParticipant,
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () async {
                  bool paid = false;
                  paid = await checkPayment(context);
                  if (paid) {
                    await shareParticipantSheet(
                      shareList,
                      pCode,
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class RoundScore extends StatefulWidget {
  List<RoundModal> roundList;
  var pointList;
  var totalPoints;
  RoundScore({
    @required this.roundList,
    @required this.pointList,
    @required this.totalPoints,
  });
  @override
  _RoundScoreState createState() => _RoundScoreState();
}

class _RoundScoreState extends State<RoundScore> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if ((widget.pointList?.length ?? 0) == 0) {
      for (int i = 0; i < widget.roundList?.length; i++)
        widget.pointList.add(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.roundList?.length
        //  == 0
        //     ? 0
        //     : (widget.roundList?.length ?? -1) + 1
        ;
    return Card(
      elevation: 2,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                // String roundName;
                // if (index == widget.roundList?.length) {
                //   roundName = 'Total';
                //   widget.pointList.add(widget.totalPoints);
                // } else {
                //   roundName = widget.roundList[index].name;
                // }
                return _itemWidget(
                  widget.roundList[index].name,
                  widget.pointList[index]?.toStringAsFixed(3),
                  kSecondaryTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          Container(
            height: 0.5,
            width: cWidth,
            color: primaryColor,
          ),
          _itemWidget(
            'Total',
            widget.totalPoints.toStringAsFixed(3),
            kPrimaryTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _itemWidget(
    String roundName,
    String points,
    TextStyle style,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: ListTile(
        title: Text(
          roundName ?? 'Name',
          style: style,
        ),
        trailing: Text(
          points ?? 'points',
          style: style,
        ),
      ),
    );
  }
}
