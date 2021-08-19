import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/database/getTeamData.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:practrCompetitions/modals/roundModal.dart';
import 'package:practrCompetitions/modals/teamModal.dart';
import 'package:practrCompetitions/resources/api/createParticipantApi.dart';
import 'package:practrCompetitions/screens/Organiser/bottomsheet/dashBottomSheet.dart';
import 'package:practrCompetitions/screens/Organiser/emptyState/emptyOrg.dart';
import 'package:practrCompetitions/screens/Organiser/participant/participantDetail.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:practrCompetitions/utils/widgets.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:file_picker/file_picker.dart';

class Participants extends StatefulWidget {
  List<TeamModal> particiList;
  List<RoundModal> roundList;
  bool loading;
  Participants({
    @required this.particiList,
    @required this.roundList,
    @required this.loading,
    Key key,
  }) : super(key: key);
  @override
  _ParticipantsState createState() => _ParticipantsState();
}

// var keyBefore;
// var dataBefore;
bool showAvailable = false;

class _ParticipantsState extends State<Participants> {
  int currentIndex = 0;
  bool qualified = true;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  updateParticipant(
    TeamModal partici,
    bool qualifiedNow,
  ) {
    //Toggle completed

    partici.qualified = qualifiedNow;
    if (partici != null) {
      _database
          .reference()
          .child("participants/$orgCompetetionId")
          .child(partici.key)
          .set(partici.toJson());
      setState(() {});
    }
  }

  loadCsvFromStorage() async {
    try {
      File result = await FilePicker.getFile(
        allowedExtensions: ['csv'],
        type: FileType.custom,
      );
      String path = result.path;
      List<List> csvData = await loadingCsvData(path);
      print(csvData);
      print('--------------');
    
      List<String> newList = [...csvData.map((e) => e[0]?.toString())];
      List<String> oldList = [...widget.particiList.map((e) => e.code)];
      print(newList);
      print(oldList);
      List<String> finalList = [];
      newList.forEach((p) {
        if (!oldList.contains(p)) finalList.add(p);
      });
      print(finalList);

      finalList.forEach((code) {
        if(code.isNotEmpty)
          createParticipant(
            context,
            widget.particiList,
            code,
          );
      });
    } catch (e) {
      print("================>CSV PARSE ERROR");
      print(e);
    }
  }

  Future<List<List<dynamic>>> loadingCsvData(String path) async {
    try {
      final csvFile = new File(path).openRead();
      print("----------------X");
      print(CsvToListConverter().convert(csvFile.toString()));
      return await csvFile
          .transform(utf8.decoder)
          .transform(
            CsvToListConverter(),
          )
          .toList();
    } catch (e) {
      print("===============>ERROR CSV READING");
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    String competitionName = orgCompetetionName;
    print("partici length: ${widget.particiList?.length}");
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: _height / 7,
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  width: _width / 1.12,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Participants",
                              style: kPrimaryTextStyle.copyWith(
                                fontSize: 36,
                              ),
                            ),
                            Text(
                              competitionName,
                              style: kPrimaryTextStyle.copyWith(
                                  fontSize: _width / 25, color: Colors.pink),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.ellipsisH,
                            color: primaryColor,
                          ),
                          onPressed: () => showOptionBottomSheet(
                            context,
                            showAvailable,
                            widget.particiList,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: widget.loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : participantItem(),
            ),
          ],
        ),
      ),
    );
  }

  Widget participantItem() {
    return widget.particiList.length == 0
        ? emptyPartici()
        : Container(
            padding: EdgeInsets.only(top: cHeight / 50),
            child: ListView(
              children: <Widget>[
                TextButton(
                  onPressed: loadCsvFromStorage,
                  child: Text(
                    "Add from CSV",
                    style: kSecondaryTextStyle.copyWith(color: primaryColor),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                CupertinoSegmentedControl<int>(
                  children: {
                    0: Text(
                      "Qualified",
                      style: kSecondaryTextStyle.copyWith(
                          color:
                              currentIndex == 0 ? Colors.white : primaryColor),
                    ),
                    1: Text(
                      "Disqualified",
                      style: kSecondaryTextStyle.copyWith(
                          color:
                              currentIndex == 1 ? Colors.white : primaryColor),
                    ),
                  },
                  onValueChanged: (int val) {
                    setState(() {
                      currentIndex = val;
                      qualified = !qualified;
                    });
                  },
                  groupValue: currentIndex,
                ),
                ParticipantList(
                  qualified: qualified,
                  data: widget.particiList,
                  roundList: widget.roundList,
                  update: updateParticipant,
                ),
                SizedBox(
                  height: cHeight / 10,
                ),
              ],
            ),
          );
  }
}

class ParticipantList extends StatefulWidget {
  final bool qualified;
  List<TeamModal> data;
  List<RoundModal> roundList;
  Function update;

  ParticipantList({
    this.qualified = true,
    @required this.data,
    @required this.roundList,
    @required this.update,
  });

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  calculatePoints() {
    int _len = widget.data?.length ?? 0;
    for (var j = 0; j < _len; j++) {
      print('calculating points now0000000000000000000000000000000000');
      int _rLen = widget.roundList.length;
      double points = 0;
      if (widget.data[j].data != null) {
        showAvailable = true;
        for (int i = 0; i < _rLen; i++) {
          double _weightage = widget.roundList[i].weightage.toDouble();
          _weightage /= 100;
          String _roundId = widget.roundList[i].taskId;

          double roundPoint = 0.0;
          int _roundLen = 0;
          widget.data[j]?.data[_roundId]?.forEach((key, value) {
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
        }
      } else {
        points = 0.0;
      }
      widget.data[j].points = points;
    }
    sortData();
  }

  bool _oneQualified = false;
  var _qualifiedLen = 0;
  var _disQualifiedLen = 0;
  bool _oneDisQualified = false;
  bool first = false;
  checkIfEmpty() {
    first = true;
    _qualifiedLen = 0;
    _disQualifiedLen = 0;
    for (var i = 0; i < widget.data.length; i++) {
      bool _isQualified = widget.data[i].qualified;
      if (_isQualified) {
        _oneQualified = true;
        _qualifiedLen++;
      } else {
        _oneDisQualified = true;
        _disQualifiedLen++;
      }
      if (_oneQualified && _oneDisQualified) break;
    }
    print("_oneQualified: $_oneQualified\n_oneDisQualified: $_oneDisQualified");
  }

  sortData() {
    for (var i = 0; i < widget.data.length; i++) {
      print("points are: ${widget.data[i].points}");
    }
    widget.data.sort((a, b) => b.points.compareTo(a.points));
  }

  List<TargetFocus> targets = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addTarget();
    _showHighlighter();
  }

  _showHighlighter() async {
    bool newUser = await getFirstPartici() ?? true;
    print("new user: $newUser");
    if (newUser) {
      Timer(Duration(seconds: 1), () => showTutorial());
    }
    if (_oneQualified) saveFirstPartici(false);
  }

  @override
  Widget build(BuildContext context) {
    checkIfEmpty();

    print(
        "qualified: ${widget.qualified} \n_oneQualified: $_oneQualified\n_oneDisQualified: $_oneDisQualified");
    return widget.qualified && !_oneQualified
        ? emptyQualified()
        : (!widget.qualified) && !_oneDisQualified
            ? emptyDisQualified()
            : buildList();
  }

  GlobalKey particiKeyHere = GlobalKey();

  void showTutorial() {
    TutorialCoachMark(context,
        targets: targets, // List<TargetFocus>
        colorShadow: primaryColor, // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        // textSkip: "SKIP",
        // paddingFocus: 10,
        // opacityShadow: 0.8,
        finish: () {
      print("finish");
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () {
      print("skip");
    })
      ..show();
  }

  addTarget() {
    targets.add(
      TargetFocus(
        shape: ShapeLightFocus.RRect,
        identify: "Target partici",
        keyTarget: particiKeyHere,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    popParticiHeader,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      popParticiContent,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var _lenPrev = 0;
  var _lenNew = 0;
  Widget buildList() {
    calculatePoints();
    _lenNew = widget.data?.length ?? 0;
    if ((_lenNew > _lenPrev) && first) {
      _qualifiedLen += _lenNew - _lenPrev;
      _lenPrev = _lenNew;
    }
    first = false;

    return ListView.builder(
      padding: EdgeInsets.only(top: 8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _lenNew,
      itemBuilder: (BuildContext context, int index) {
        String pCode = widget.data[index].code; // participant code
        bool _isQualified = widget.data[index].qualified;
        String points = widget.data[index].points?.toStringAsFixed(3) ?? "0.0";
        {
          points = widget.data[index].points.toStringAsFixed(3);
        }
        GlobalKey _tutKey = index == 0 ? particiKeyHere : null;
        if (widget.qualified != _isQualified) {
          return Container();
        }
        String type = !widget.qualified ? 'Qualified' : 'Disqualified';
        Key key = Key(pCode);
        return InkWell(
          key: _tutKey,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ParticipantDetail(
                  particilist: widget.data,
                  particiIndex: index,
                  roundList: widget.roundList,
                ),
              ),
            );
          },
          child: Dismissible(
            key: key,
            background: Container(
              alignment: Alignment.center,
              color: widget.qualified ? Colors.red : Colors.green,
            ),
            onDismissed: (direction) async {
              // String type = !qualified ? 'qualified' : 'disqualified';
              widget.qualified
                  ? widget.update(widget.data[index], false)
                  : widget.update(widget.data[index], true);

              Fluttertoast.showToast(
                msg: "$pCode $type!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 5,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              if (widget.qualified) {
                _qualifiedLen--;
                if (_qualifiedLen <= 0) {
                  _oneQualified = false;
                  if (mounted) setState(() {});
                }
                print("qualifiend length................: $_qualifiedLen");
              } else {
                _disQualifiedLen--;
                if (_disQualifiedLen <= 0) {
                  _oneDisQualified = false;
                  if (mounted) setState(() {});
                }

                print(
                    "disqualifiend length...................: $_disQualifiedLen");
              }
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      pCode?.substring(0, 1)?.toUpperCase() ?? "T",
                      style: widget.qualified
                          ? kPrimaryTextStyle
                          : kPrimaryTextStyle.copyWith(color: Colors.white),
                    ),
                    backgroundColor:
                        widget.qualified ? Colors.greenAccent : Colors.red,
                  ),
                  trailing: IconButton(
                      // padding: EdgeInsets.only(right: 0),
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        widget.qualified
                            ? Icons.remove_circle
                            : Icons.add_circle,
                        color:
                            widget.qualified ? Colors.red : Colors.greenAccent,
                      ),
                      onPressed: () {
                        print("deleting circle");
                        widget.qualified
                            ? widget.update(widget.data[index], false)
                            : widget.update(widget.data[index], true);
                      }),
                  title: Text(
                    pCode ?? "Participant Code",
                    // ${teamCode[index]}",
                    style: kSecondaryTextStyle,
                  ),
                  subtitle: Text(
                    "$points Points",
                    style: kPrimaryTextStyle.copyWith(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

final TextEditingController enterParticipantCodeController =
    TextEditingController();

class EnterParticipantCode extends StatefulWidget {
  var particiList;
  EnterParticipantCode({
    @required this.particiList,
  });
  @override
  _EnterParticipantCodeState createState() => _EnterParticipantCodeState();
}

class _EnterParticipantCodeState extends State<EnterParticipantCode> {
  @override
  void initState() {
    super.initState();
    enterParticipantCodeController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    // print("data in previous: ${widget.particiList}");
    return SingleFieldForm(
      title: "Enter Participant Code",
      hintText: "",
      labelText: "type here..",
      routerString: "orgHome",
      btnText: "Add Participant",
      inputLeadingWidget: Container(),
      controller: enterParticipantCodeController,
      name: false,
      pushNamedAndRemoveUntil: false,
      type: 'partici',
      context: context,
      textCapitalization: TextCapitalization.sentences,
      dataForm: widget.particiList,
    );
  }
}
