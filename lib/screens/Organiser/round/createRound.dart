import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/common/function.dart';
import 'package:practrCompetitions/database/getTeamData.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:practrCompetitions/modals/orgSkill.dart';
import 'package:practrCompetitions/modals/roundModal.dart';
import 'package:practrCompetitions/resources/api/createTaskApi.dart';
import 'package:practrCompetitions/resources/api/updateTaskApi.dart';
import 'package:practrCompetitions/screens/Organiser/emptyState/emptyOrg.dart';
import 'package:practrCompetitions/screens/Organiser/home.dart';
import 'package:practrCompetitions/screens/Organiser/round/enterCriteria.dart';
import 'package:practrCompetitions/screens/route/fadeRoute.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'editCriteria.dart';

class CreateRound extends StatefulWidget {
  final List<RoundModal> roundList;
  final RoundModal data;
  final bool firstTime;
  final String taskIdHere;
  final bool canChange;
  CreateRound({
    @required this.roundList,
    this.data,
    this.firstTime = true,
    this.taskIdHere,
    this.canChange = true,
  });
  @override
  _CreateRoundState createState() => _CreateRoundState();
}

class _CreateRoundState extends State<CreateRound> {
  bool _switch = false;
  double value = 100;
  int totalPoint = 0;
  bool host = false; // to check if skills length is greater than 1
  bool _creatingLive = false; // to create round to live
  String secretCode = '';
  String pRoundName = '';
  refresh(int point) {
    setState(() {
      totalPoint = point;
    });
  }

  var subscription;

  TextEditingController taskNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<OrgSkill> skills = List();
  Future<bool> createTaskFunction(BuildContext context) async {
    bool success = false;
    bool _roundNameExist = false;

// widget.roundList[0].name;
    print("list ${widget.roundList.length}");
    for (var item in widget.roundList) {
      if (item.name == taskNameController.text &&
          taskNameController.text != pRoundName) {
        _roundNameExist = true;
        break;
      }
    }
    if (!_roundNameExist) {
      if (widget.firstTime) {
        print("creating task!");

        secretCode = await secretCodeGenerator();
        success = await createTask(
          context,
          taskNameController.text,
          _switch == false ? 0 : 1,
          value.toInt(),
          skills,
          secretCode,
        );
      } else {
        print("updating task");
        success = await updateTask(
          context,
          taskNameController.text,
          _switch == false ? 0 : 1,
          value.toInt(),
          skills,
          widget.data.secretCode,
          widget.data.taskId,
        );
      }

      if (!success) {
        errorDialog(
          context,
          "Try Again!!",
          "Not able to connnect!!",
        );
      } else {
        pRoundName = taskNameController.text;
      }
    } else {
      errorDialog(
        context,
        "Sorry!!",
        "Please change round title. Round Title already exist!!",
      );
    }
    return success;
  }

  deleteTask(BuildContext context) async {
    // print(
    //     "data is here: ${widget.data.key}\nruntimeType: ${widget.data.runtimeType}");
    String taskKey = widget.data.key;
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('task/$taskKey')
          .remove();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => OrganiserHome(),
        ),
        (Route<dynamic> round) => false,
      );
      // errorDialog(
      //   context,
      //   "Success",
      //   "Successfully deleted!",
      // );
    } catch (e) {
      // print("it is error $e");
      errorDialog(
        context,
        'Retry!!',
        "Error removing entry!!",
      );
    }
  }

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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
      print("host $host");
      if (taskNameController.text != "" && skills.length > 0) {
        host = true;

        showHighlighter();
      } else {
        host = false;
      }
    }
  }

  List<TargetFocus> targets = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.firstTime) {
      pRoundName = widget.data.name;

      taskNameController.text = pRoundName;
      value = widget.data.weightage.toDouble();
      _switch = widget.data.live == 0 ? false : true;

      totalPoint = 0;
      int len = widget.data.skills?.length ?? 0;
      for (int i = 0; i < len; i++) {
        OrgSkill skillHere = OrgSkill(
          maxScore: (widget.data.skills[i].maxScore.toInt()),
          name: widget.data.skills[i].name,
        );
        totalPoint += widget.data.skills[i].maxScore.toInt();
        skills.add(skillHere);
      }
      secretCode = widget.data.secretCode;
    }
    taskNameController.addListener(() {
      if (taskNameController.text != "" && skills.length > 0) {
        host = true;

        showHighlighter();
      } else {
        host = false;
      }
      print("host here is: $host");
    });
    if (taskNameController.text != "" && skills.length > 0) {
      host = true;

      showHighlighter();
    } else {
      host = false;
    }

    addTarget();
  }

  showHighlighter() async {
    bool newUser = await getNewUser() ?? true;
    print("new user: $newUser");
    if (newUser) {
      Timer(Duration(seconds: 1), () => showTutorial());
    }
    saveNewUser(false);
  }

  GlobalKey switchKeyHere = GlobalKey();

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
        TargetFocus(identify: "Target 1", keyTarget: switchKeyHere, contents: [
      ContentTarget(
          align: AlignContent.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  popLiveHeader,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    popLiveContent,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ))
    ]));
  }

  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _switch
          ? Container()
          : FloatingActionButton(
              heroTag: 'CreateSkill',
              child: const Icon(Icons.playlist_add),
              onPressed: () {
                Navigator.push(
                  context,
                  FadeRoute(
                    page: EnterCriteria(
                      controller: nameController,
                      skills: skills,
                      host: host,
                      totalPoint: totalPoint,
                      notify: refresh,
                    ),
                  ),
                );
              },
            ),
      // resizeToAvoidBottomPadding: false,
      bottomNavigationBar: _switch
          ? Container(
              height: 0,
            )
          : bottomAppBar(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
        title: _switch
            ? Text(
                "Live",
                style: kPrimaryTextStyle.copyWith(color: Colors.pink),
              )
            : Text(
                "Draft",
                style: kPrimaryTextStyle.copyWith(color: Colors.grey),
              ),
        actions: <Widget>[
          _creatingLive
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CupertinoSwitch(
                    // materialTapTargetSize: MaterialTapTargetSize.padded,
                    key: switchKeyHere,
                    value: _switch,
                    onChanged: !host
                        ? null
                        : (bool value) async {
                            if (widget.canChange) {
                              setState(() {
                                _switch = value;
                                _creatingLive = true;
                              });

                              bool success = value
                                  ? await createTaskFunction(context)
                                  : await updateTaskToDraft(
                                      context,
                                      _switch == false ? 0 : 1,
                                      widget.data?.taskId ?? secretCode,
                                    );

                              setState(() {
                                _creatingLive = false;
                              });
                              if (value && success) {
                                // if (widget.firstTime) Navigator.pop(context);
                                copyDialog(
                                  context,
                                  "Success",
                                  'Share this code (case sensitive) with your judges to begin scoring process',
                                  secretCode,
                                );
                              } else if (!success) {
                                setState(() {
                                  _switch = !value;
                                });
                              }
                            } else {
                              print(
                                  "delete judge data before changing to draft");
                              errorDialog(
                                context,
                                "Sorry!!",
                                "Please remove judge data before changing data Information.",
                              );
                            }
                          },
                    activeColor: Colors.pink,
                  ),
                )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: _switch
                              ? EdgeInsets.symmetric(horizontal: 8)
                              : EdgeInsets.all(0),
                          child: TextFormField(
                            enabled: !_switch,
                            autofocus:
                                //  false,
                                !host,
                            controller: taskNameController,
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
                                fontSize: _width / 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "$totalPoint Pts",
                          style: kPrimaryTextStyle,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              flex: 6,
              child: skills.length == 0
                  ? emptyCriteria()
                  : ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 8,
                          ),
                          child: Text(
                            "Create or modify judgement criterias",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 20, 16, 32),
                          child: CriteriaCard(
                            notify: refresh,
                            live: _switch,
                            skills: skills,
                          ),
                        )
                      ],
                    ),
            ),
            skills.length == 0
                ? Container()
                : Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Weightage",
                                style: kPrimaryTextStyle,
                              ),
                              Text(
                                value.floor().toString() + "%",
                                style: kPrimaryTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 16,
                          ),
                          child: Slider(
                            // inactiveColor: Colors.grey,
                            value: value,
                            min: 0,
                            max: 200,
                            onChanged:
                                //  _switch
                                //     ? null
                                //     :
                                (double newValue) {
                              setState(() {
                                value = newValue;
                              });
                            },
                            onChangeEnd: (double newValue) async {
                              if (_switch) {
                                print(
                                    " on changeEnd new value here is: $newValue");
                                value = newValue;
                                await FirebaseDatabase.instance
                                    .reference()
                                    .child('task/${widget.taskIdHere}')
                                    .update({'weightage': value.toInt()});
                              }
                            },
                          ),
                        ),
                      ],
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
      shape: _switch ? null : CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: _isDeleting
                ? null
                : () {
                    setState(() {
                      _isDeleting = true;
                    });
                    if (widget.firstTime) {
                      Navigator.pop(context);
                    } else {
                      confirmDialog(
                        context,
                        'Are you sure?',
                        'Tap confirm to permanently delete this round',
                        deleteTask,
                      );
                      setState(() {
                        _isDeleting = false;
                      });
                      // deleteTask(context);
                    }
                  },
          ),
          IconButton(
            icon: Icon(
              Icons.save,
              color:
                  taskNameController.text == "" ? Colors.grey : Colors.yellow,
            ),
            onPressed: taskNameController.text == ""
                ? giveHint
                : _isSaving
                    ? null
                    : () async {
                        setState(() {
                          _isSaving = true;
                        });
                        bool success = await createTaskFunction(context);
                        setState(() {
                          _isSaving = false;
                        });
                        if (success) {
                          Navigator.pop(context);
                        }
                      },
          ),
        ],
      ),
    );
  }
}

class CriteriaCard extends StatefulWidget {
  final Function notify;
  final bool live;
  List<OrgSkill> skills;
  CriteriaCard({
    @required this.notify,
    @required this.live,
    @required this.skills,
  });
  @override
  _CriteriaCardState createState() => _CriteriaCardState();
}

class _CriteriaCardState extends State<CriteriaCard> {
  List<double> _currentPrice = List.filled(150, 1.0, growable: true);
  int total = 0;

  void _showDialog(int index) {
    showDialog<double>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.decimal(
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(15),
            ),
            cancelWidget: Text(
              'CANCEL',
              style: kSecondaryTextStyle,
            ),
            confirmWidget: Text(
              'OK',
              style: kSecondaryTextStyle,
            ),
            minValue: 0,
            maxValue: 10,
            title: Text(
              criteriaWeightageHeader,
              style: kSecondaryTextStyle,
            ),
            initialDoubleValue: _currentPrice[index],
          );
        }).then((double value) {
      if (value != null) {
        if ((value * 10).toInt() < 5) {
          errorDialog(
            context,
            minimumCriteriaPointsHeader,
            minimumCriteriaPointsBody,
          );
        } else {
          setState(() {
            total -= (_currentPrice[index] * 10).toInt();
            total += (value * 10).toInt();
            _currentPrice[index] = value;
            widget.skills[index] = OrgSkill(
              maxScore: (value * 10).toInt(),
              name: widget.skills[index].name,
            );
            widget.notify(total);
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.skills.length; i++) {
      _currentPrice[i] =
          ((widget.skills[i]?.maxScore?.toDouble() ?? 0.0) / 10) ?? 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    total = 0;
    return Card(
      elevation: 2,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.skills.length,
        itemBuilder: (BuildContext context, int index) {
          total += (_currentPrice[index] * 10).toInt();
          String name = widget.skills[index]?.name ?? "Not Found";
          return ListTile(
            title: InkWell(
              onTap: () {
                print('item edited started');
//                EditCriteria()
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCriteria(
                      skills: widget.skills,
                      index: index,
                      name: name,
                    ),
                  ),
                );
              },
              child: Container(
                width: cWidth * 0.52,
                child: Text(
                  name ?? 'Skill',
                  style: kSecondaryTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            leading: widget.live
                ? IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () {},
                  )
                : IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.blue,
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.skills.removeAt(index);
                        total -= (_currentPrice[index] * 10).toInt();
                        _currentPrice.removeAt(index);
                      });
                      widget.notify(total);
                    },
                  ),
            trailing: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () => widget.live ? null : _showDialog(index),
              // iconSize: 35,
              color: Colors.transparent,
              child: Text(
                (_currentPrice[index] * 10).toString().replaceFirst('.0', ''),
                style: kPrimaryTextStyle.copyWith(
                  color: widget.live
                      ? primaryColor
                      : primaryColor.withOpacity(0.75),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData buttonIcon;
  final Function function;

  RoundIconButton({this.buttonIcon, this.function});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(buttonIcon),
      onPressed: function,
      elevation: 6,
      constraints: BoxConstraints.tightFor(width: 56, height: 56),
      shape: CircleBorder(),
      fillColor: Color(0xFF4C4F5E),
    );
  }
}

class RoundTextButton extends StatelessWidget {
  final String text;
  final Function function;

  RoundTextButton({this.text, this.function});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Text(text),
      onPressed: function,
      elevation: 6,
      constraints: BoxConstraints.tightFor(width: 56, height: 56),
      shape: CircleBorder(),
      fillColor: Color(0xFF4C4F5E),
    );
  }
}
