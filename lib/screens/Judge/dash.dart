import 'dart:async';

import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/fancy_dialog_edit.dart';
import 'package:practrCompetitions/database/getTeamData.dart';
import 'package:practrCompetitions/database/saveTeamData.dart';
import 'package:practrCompetitions/login/JudgeLoginPage.dart';
import 'package:practrCompetitions/modals/scoreModal.dart';
import 'package:practrCompetitions/modals/taskModal.dart';
import 'package:practrCompetitions/modals/teamModal.dart';
import 'package:practrCompetitions/screens/Judge/judge_slider.dart';
import 'package:practrCompetitions/screens/route/scaleRoute.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:practrCompetitions/utils/widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../main.dart';

List<int> totalScore =
    List.filled(0, 0, growable: true); // total score of submitted

int highest = 0;
int highestIndex = -1;
int lowestIndex = -1;
int lowest = 1000000;
bool showScore = false;
int average = 0;
var data;
var skills;

double _totalMaxValue = 0.0; // total of maximum score

class JudgeDash extends StatefulWidget {
  // final String judgeName;
  // JudgeDash({
  //   @required this.judgeName,
  // });
  @override
  _JudgeDashState createState() => _JudgeDashState();
}

class _JudgeDashState extends State<JudgeDash> {
  bool _isLoading = true;
  List<User> user = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  refresh() {
    setState(() {});
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  Future<dynamic> loadData() async {
    print("user length here is: ${user.length}");
    // if (data == null) {
    data = _teamList;
    // }
    int _len = data?.length ?? 0;

    // print("data len: $_len user length: ${user?.length ?? -1}");
    if ((user?.length ?? 0) < _len) {
      int i = 0;

      for (i = 0; i < _len; i++) {
        if (totalScore.length >= _len) break;
        totalScore.add(0);
      }
      for (i = 0; i < _len; i++) {
        if (user.length >= _len) break;
        user.add(User());
      }

      // print("data has loaded length: $_len");

      List<String> ids = List();
      for (var i = 0; i < _len; i++) {
        String id = data[i].participantId.toString();
        ids.add(id);
      }
      // loop to load data when load first from sharedPreferences.
      i = 0;
      for (String id in ids) {
        // totalScore[i] = await getTotalScore(id.toString()) ?? 0;
        // print("totaoScore $i $totalScore");
        var _skillLen = skills?.length ?? 0;
        List<int> score = List.filled(_skillLen, 0, growable: true);

        var teamData = await getIdData(id.toString());

        totalScore[i] = 0;
        if (teamData[2] != null) {
          user[i].mesg = teamData[1];

          totalScore[i] = 0;
          for (int j = 0; j < teamData[0]?.length ?? 0; j++) {
            if (j < _skillLen) {
              score[j] = int.parse(teamData[0][j]);

              if (score[j] > skills[j].maxScore) {
                score[j] = 0;
              }
              totalScore[i] += score[j].toInt();
            } else {
              totalScore[i] += int.parse(teamData[0][j]);
            }
          }

          List<Skill> skillHere = List();

          for (int j = 0; j < _skillLen; j++) {
            int emojiCount = ((score[j] * 5) / (skills[j].maxScore)).ceil();

            Skill skillNow = Skill(
              name: skills[j].name,
              score: score[j],
              emoji: emojiCount,
            );
            skillHere.add(skillNow);
          }
          user[i].skill = skillHere;
          user[i].total = totalScore[i].toInt();
        }
        i++;
      }
    }
  }

  loadFirstData() {
    // skills = dataIncoming["skills"];
    // print("skills length type: ${skills.runtimeType} ${skills.length}");
    // print("dataIncoming skills: ${dataIncoming["skills"]}");

    // _totalMaxValue = 0;
    // for (int i = 0; i < contestData["skills"].length; i++) {
    //   _totalMaxValue += contestData["skills"][i]["maxScore"]?.toDouble() ?? 0.0;
    //   // print("00000000000_totalMaxValue $i: ${skills[i]["maxScore"]}");
    // }
  }
  List<Skill> zeroList = List();
  addTotalScore() {
    _totalMaxValue = 0;
    for (int i = 0; i < skills.length; i++) {
      _totalMaxValue += skills[i].maxScore?.toDouble() ?? 0.0;
      // print("00000000000_totalMaxValue $i: ${skills[i]["maxScore"]}");
      Skill zeroSkill = Skill(
        emoji: 0,
        score: 0,
        name: skills[i]?.name ?? '',
      );
      if (zeroList.length <= i) {
        zeroList.add(zeroSkill);
      } else {
        zeroList[i] = zeroSkill;
      }
    }
  }

  int numberOfUser = 0;

  // listning task modal
  bool _skillLoading = true;
  Query _taskQuery;
  List<TaskModal> _taskList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onTaskModalAddedSubscription;

  StreamSubscription<Event> _onTaskModalChangedSubscription;

  // listning participant modal
  bool _teamLoading = true;

  Query _teamQuery;
  List<TeamModal> _teamList;

  StreamSubscription<Event> _onTeamModalAddedSubscription;
  StreamSubscription<Event> _onTeamModalValueSubscription;

  StreamSubscription<Event> _onTeamModalChangedSubscription;
  StreamSubscription<Event> _onTeamModalRemovedSubscription;

  @override
  void initState() {
    super.initState();
    // loadFirstData();

    _taskList = new List();
    _teamList = new List();
    if (_taskQuery == null) {
      // print("task query: $_taskQuery");

      _taskQuery = _database
          .reference()
          .child("task")
          .orderByChild("secretCode")
          .equalTo(secretCodeHere);
    }
    if (_teamQuery == null) {
      // print("team query: $_teamQuery");

      _teamQuery = _database.reference().child('participants/$competetionId');
    }

    _onTaskModalAddedSubscription =
        _taskQuery.onChildAdded.listen(onTaskEntryAdded);
    _onTaskModalChangedSubscription =
        _taskQuery.onChildChanged.listen(onTaskEntryChanged);
    // loadData();

    _onTeamModalAddedSubscription =
        _teamQuery.onChildAdded.listen(onTeamEntryAdded);
    _onTeamModalChangedSubscription =
        _teamQuery.onChildChanged.listen(onTeamEntryChanged);
    _onTeamModalRemovedSubscription =
        _teamQuery.onChildRemoved.listen(onTeamEntryRemoved);
    _onTeamModalValueSubscription = _teamQuery.onValue.listen(onTeamEntryValue);

    loadData();
  }

  @override
  void dispose() {
    _onTaskModalAddedSubscription?.cancel();
    _onTaskModalChangedSubscription?.cancel();

    _onTeamModalAddedSubscription?.cancel();
    _onTeamModalChangedSubscription?.cancel();
    _onTeamModalRemovedSubscription?.cancel();
    _onTeamModalValueSubscription?.cancel();

    super.dispose();
  }

  onTaskEntryChanged(Event event) {
    var oldEntry = _taskList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _taskList[_taskList.indexOf(oldEntry)] =
          TaskModal.fromSnapshot(event.snapshot);

      contestTitle = _taskList[0].competetionName;
      competetionId = _taskList[0].competetionId;
      taskId = _taskList[0].taskId;
      taskTitle = _taskList[0].name;
      skills = _taskList[0].skills;
      _skillLoading = false;
      judgeOrgToken = _taskList[0].orgToken;

      addTotalScore();
    });
  }

  onTaskEntryAdded(Event event) {
    setState(() {
      _taskList.add(TaskModal.fromSnapshot(event.snapshot));

      contestTitle = _taskList[0].competetionName;
      competetionId = _taskList[0].competetionId;
      taskId = _taskList[0].taskId;
      taskTitle = _taskList[0].name;
      skills = _taskList[0].skills;
      _skillLoading = false;
      judgeOrgToken = _taskList[0].orgToken;
      addTotalScore();
    });
  }

  onTeamEntryRemoved(Event event) {
    // print(
    //     "team entry should be removed \nkey:${event.snapshot.key} \nvalue:${event.snapshot.value}");
    var oldEntry = _teamList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    // print("teamlist before len: ${_teamList.length}");
    setState(() {
      var index = _teamList.indexOf(oldEntry);
      print("index to be leaved: $index");
      _teamList.removeAt(_teamList.indexOf(oldEntry));
      // _teamList.remove(
      //   TeamModal.fromSnapshot(event.snapshot),
      // );
    });

    // print("temlist after len: ${_teamList.length}");
  }

  onTeamEntryChanged(Event event) {
    var oldEntry = _teamList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _teamList[_teamList.indexOf(oldEntry)] =
          TeamModal.fromSnapshot(event.snapshot);
      _teamLoading = false;
      numberOfUser = _taskList?.length ?? 0;
      loadData();
    });

    // print("onTeam entry changed!!");
  }

  onTeamEntryAdded(Event event) {
    setState(() {
      _teamList.add(TeamModal.fromSnapshot(event.snapshot));
      _teamLoading = false;
      numberOfUser = _taskList?.length ?? 0;
      loadData();
    });
  }

  onTeamEntryValue(Event event) {
    _onTeamModalValueSubscription?.cancel();
    print("value has come in dash now00000000000000000");
    setState(() {
      _isLoading = false;
    });
  }

  empty() {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              padding: EdgeInsets.all(
                15.0,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "You are Judging",
                        style:
                            kSecondaryTextStyle.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          taskTitle ?? "Contest Title",
                          style:
                              kPrimaryTextStyle.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            preferredSize: Size(cHeight / 5, 100)),
      ),
      body: _isLoading
          ? Container(
              // color: Colors.green,
              height: cHeight * 0.8,
              // width: cWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(8),
              height: cHeight * 0.55,
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
                      // height: cHeight * 0.7,
                      width: cWidth,
                    ),
                  ),
                  Container(
                    height: cHeight * 0.04,
                  ),
                  Container(
                    child: Text(
                      participantEmptyState,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: cWidth * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return FancyDialog(
              title: 'Are you sure?',
              animationType: FancyAnimation.TOP_BOTTOM,
              descreption: 'Do you want to exit an App',
              okFun: () {
                Navigator.of(context).pop(true);
              },
              okColor: primaryColor,
              ok: 'Yes',
              cancel: 'No',
              cancelFun: () {
                Navigator.of(context).pop(false);
              },
              popScreen: false,
            );
          },
        ) ??
        false;
  }

  checkRankUser() {
    int _len = totalScore?.length ?? 0;
    int _showLen = 0;
    average = 0;
    for (int i = 0; i < _len; i++) {
      // For highest
      if ((totalScore[i] >= highest) || (i == highestIndex)) {
        highest = totalScore[i]; // to get highest initial
        highestIndex = i;
      }
      // For lowest
      if ((lowest >= totalScore[i] && totalScore[i] != 0) ||
          (i == lowestIndex)) {
        lowest = totalScore[i];
        lowestIndex = i;
      }
      // For average and to show or not
      if (totalScore[i] > 0) {
        average += totalScore[i];
        _showLen++;
      }
    }

    // check to show or not

    showScore = false;
    if (_showLen > 2) {
      showScore = true;
      average ~/= _showLen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: childJudge(context),
    );
  }

  Widget childJudge(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    print("_teamList in build : ${_teamList.length} ${_taskList.isEmpty} ");
    numberOfUser = _teamList?.length ?? 0;
    checkRankUser();
    // loadFirstData();
    // print("numberof user are: $numberOfUser");
    return
        // _skillLoading || _teamLoading
        //     ? empty()
        //     :
        numberOfUser == 0
            ? empty()
            : Scaffold(
                key: _scaffoldKey,
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    int userLen = user.length;

                    for (int i = userLen - 1;; i--) {
                      if (user.length == numberOfUser) break;
                      user.removeAt(i);
                    }

                    ScoreModal scoreModal = ScoreModal(
                      judgeName: nameController.text,
                      taskSecret: secretCodeController.text,
                      taskId: taskId,
                      competetionId: competetionId,
                      user: user,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmSubmission(
                          modal: scoreModal,
                        ),
                      ),
                    );
                  },
                  label: Text(
                    "Submit",
                    style: kButtonTextStyle.copyWith(color: primaryColor),
                  ),
                  icon: Icon(
                    Icons.check,
                    color: Color(0xFF382176),
                  ),
                ),
                backgroundColor: Color(0xFF382176),
                appBar: AppBar(
                  bottom: PreferredSize(
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(
                            15.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "You are Judging",
                                    style: kSecondaryTextStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                  !showScore
                                      ? Container(
                                          // height: 0,
                                          // width: 0,
                                          )
                                      : Container(
                                          padding: EdgeInsets.only(
                                            right: 15.0,
                                          ),
                                          child: Chip(
                                            label: Text(
                                              'Avg: $average',
                                              style:
                                                  kSecondaryTextStyle.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                            backgroundColor: Colors.orange,
                                          ),
                                        )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      taskTitle ?? "Contest Title",
                                      style: kPrimaryTextStyle.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      preferredSize: Size(_height / 5, 100)),
                ),
                body: ScrollConfiguration(
                  behavior: BounceScrollBehavior(),
                  child: itemHere(),
                ),
              );
  }

  Widget itemHere() {
    // print("listview loading numberOfUser: $numberOfUser");
    return ListView(
      children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: numberOfUser,
          itemBuilder: (BuildContext context, int index) {
            if (user.isEmpty) {
              return Container(
                child: Text("user length: ${user?.length ?? 0}"),
              );
            }
            String code =
                // index + 1;
                _teamList[index].code;
            String participantId =
                // index + 1;
                _teamList[index].participantId;
            // print(
            //     'totalScore: ${totalScore[index]} totalMaxvalue: $_totalMaxValue');
            // print(
            //     "totalMax value: $_totalMaxValue\n totalScore $index length: ${totalScore?.length ?? 0}");
            int emojiCount = 0;
            emojiCount = ((totalScore[index] ~/
                        ((_totalMaxValue == 0.0 ? 5 : _totalMaxValue) / 5) +
                    1)) ??
                0;
            if (emojiCount > 5) {
              emojiCount = 5;
            }

            bool qualified = _teamList[index]?.qualified ?? false;
            // print(
            //     "snapshotData inn dash: ${snapshotData[keys[index]]}");
            user[index].id = participantId.toString();
            user[index].email = _teamList[index].phoneNo;
            // user[index].name = _teamList[index].name;
            user[index].teamCode = _teamList[index].code;
            user[index].qualified = qualified;
            if (user[index].skill == null) {
              user[index].skill = zeroList;
              user[index].total = 0;
            }

            // if(user[index].skill == null){
            //   user[index].skill = []
            // }

            bool notMarked = totalScore[index] == null || totalScore[index] == 0
                ? true
                : false;

            String scoreHere =
                notMarked ? "Not marked Yet" : "${totalScore[index]} pts";

            String emoji = notMarked
                ? "assets/" + "0emoji.gif"
                : "assets/" + emojiCount.toString() + "emoji.gif";

            var icon = index == highestIndex
                ? Chip(
                    label: Text(
                      'Highest',
                      style: kSecondaryTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                  )
                : index == lowestIndex
                    ? Chip(
                        label: Text(
                          'Lowest',
                          style: kSecondaryTextStyle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: CupertinoColors.destructiveRed,
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      );

            return !qualified
                ? Container()
                : InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        // CupertinoPageRoute(
                        //   builder: (context) => SubmitAlert(
                        //     indexHere: index,
                        //     notify: refresh,
                        //     teamId: participantId,
                        //     teamCode: code,
                        //     user: user,
                        //   ),
                        // ),
                        ScaleRoute(
                          page: SubmitAlert(
                            indexHere: index,
                            notify: refresh,
                            teamId: participantId,
                            teamCode: code,
                            user: user,
                          ),
                        ),
                      );
                      // showDialog(
                      //   context: context,
                      //   builder: (_) => SubmitAlert(
                      //     indexHere: index,
                      //     notify: refresh,
                      //     teamId: participantId,
                      //     user: user,
                      //   ),
                      // );
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
                            backgroundColor: Colors.transparent,
                            radius: 24,
                            backgroundImage: AssetImage(
                              emoji,
                            ),
                          ),
                          title: Text(
                            code ?? "Team Naveen",
                            // ${teamCode[index]}",
                            style: kSecondaryTextStyle.copyWith(
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            scoreHere ?? '0',
                            style: kSecondaryTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          trailing: !showScore
                              ? Container(
                                  width: 0,
                                  height: 0,
                                )
                              : icon,
                          // isThreeLine: showScore,
                        ),
                      ),
                    ),
                  );
          },
        ),
        SizedBox(
          height: 80,
        ),
      ],
    );
  }
}

class SubmitAlert extends StatefulWidget {
  Function notify;
  final int indexHere;
  final teamId;
  final teamCode;
  List<User> user;
  SubmitAlert({
    this.indexHere,
    this.notify,
    this.teamId,
    this.teamCode,
    this.user,
  });
  @override
  State<StatefulWidget> createState() => SubmitAlertState();
}

class SubmitAlertState extends State<SubmitAlert>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  List<int> score = List.filled(
    (skills?.length ?? 100) + 1,
    0,
    growable: true,
  );
  // ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // print("skills length is: ${skills.length}");

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    checkTeamData();
  }

  refresh() {
    if (mounted) {
      setState(() {
        totalScore[widget.indexHere] = 0;
        for (int i = 0; i < skills.length; i++) {
          totalScore[widget.indexHere] += score[i]?.toInt() ?? 0;
        }
      });
      // widget.notify();
    }
  }

  // bool _isOnTop = true;
  // _scrollToBottom() {
  //   _scrollController.animateTo(
  //     100.0,
  //     duration: Duration(milliseconds: 1000),
  //     curve: Curves.easeOut,
  //   );
  //   setState(() => _isOnTop = false);
  // }

  _onRefresh() {
    setState(() {
      totalScore[widget.indexHere] = 0;
      for (int i = 0; i < skills.length; i++) {
        score[i] = 0;
      }
    });

    submitData();
  }

  bool teamDataExist = false;
  TextEditingController _mesgController = TextEditingController();

  checkTeamData() async {
    var teamData = await getIdData(widget.teamId.toString());
    bool change = false;
    if (teamData[2] != null) {
      setState(() {
        teamDataExist = true;
        _mesgController.text = teamData[1];
        totalScore[widget.indexHere] = 0;
        // // print("team length: ${teamData[0]?.length}");
        var _skillLen = skills?.length ?? 0;
        for (int i = 0; i < teamData[0]?.length ?? 0; i++) {
          if (i < _skillLen) {
            score[i] = int.parse(teamData[0][i]);
            if (score[i] > skills[i]?.maxScore) {
              score[i] = 0;
              teamData[0][i] = '0';
              change = true;
            }
            totalScore[widget.indexHere] += score[i].toInt();
          }
        }
      });
      if (change) {
        saveData(
          widget.teamId,
          teamData[0],
          teamData[1],
          teamData[2],
        );
      }
    }
  }

  submitData() async {
    // print('Submit data is called:3333333333333333333333333');
    // saveIds
    if (!teamDataExist) {
      List<String> teamIds = await getIds() ?? List();
      // print("temIds present: $teamIds");
      teamIds.add(widget.teamId.toString());
      await saveIds(teamIds);
    }
    // save data
    List<String> skill = score.map((value) => value.toString()).toList();

    totalScore[widget.indexHere] = 0;
    for (int i = 0; i < skills.length ?? 0; i++) {
      totalScore[widget.indexHere] += score[i].toInt();
    }

    widget.notify();
    await saveData(
      widget.teamId.toString(),
      skill,
      _mesgController.text.toString(),
      totalScore[widget.indexHere]?.toInt(),
    );
    //  save in modal -> user
    List<Skill> skillHere = List();

    for (int i = 0; i < skills.length; i++) {
      int emojiCount = ((score[i] * 5) / (skills[i].maxScore)).ceil();

      Skill skillNow = Skill(
        name: skills[i].name,
        score: score[i],
        emoji: emojiCount,
      );
      skillHere.add(skillNow);
    }
    // // print("skills here are: $skillHere");
    // checkIndex = -1;
    widget.user[widget.indexHere].skill = skillHere;
    widget.user[widget.indexHere].total = totalScore[widget.indexHere].toInt();
    if (_mesgController.text != null) {
      widget.user[widget.indexHere].mesg = _mesgController.text;
    }
    // print(
    //     "user here at ${widget.indexHere} is: ${widget.user[widget.indexHere].email}");
    // print("user here at 2 is: ${widget.user[2].email}");
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return SafeArea(
      bottom: false,
      child: Container(
        color: Colors.grey[100],
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Material(
                // color: Colors.green,
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        padding: EdgeInsets.zero,
                        // controller: _scrollController,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                    ),
                                    height: 100,
                                    width: 75,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    "${totalScore[widget.indexHere]} pts",
                                    style: kPrimaryTextStyle.copyWith(
                                      // color: Colors.pink,
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: IconButton(
                                    onPressed: () {
                                      confirmAlert(context);
                                    },
                                    icon: Icon(
                                      Icons.restore,
                                      // color: Colors.pink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  // color: Colors.green,
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    bottom: 15,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "You are Judging",
                                            style: kSecondaryTextStyle.copyWith(
                                                // color: Colors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              widget.teamCode ?? "Team Name",
                                              style: kPrimaryTextStyle.copyWith(
                                                fontSize: 28,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 15,
                                      // )
                                    ],
                                  ),
                                ),
                                CriteriaListItems(
                                  saveData: submitData,
                                  notify: refresh,
                                  score: score,
                                ),
                                SizedBox(
                                  height: _height / 60,
                                ),
                                AppTextField(
                                  controller: _mesgController,
                                  maxlines: 3,
                                  hintText: hintJudgeCriteria,
                                  autofocus: false,
                                ),
                                SizedBox(
                                  height: _height / 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    LargeButton(
                                      style: kButtonTextStyle.copyWith(
                                          fontSize: 20),
                                      btnTxt: "Done",
                                      function: () {
                                        submitData();
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop('dialog');
                                      },
                                      horizontalPadding: 10,
                                      verticalPadding: 10,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      !showScore
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 50,
                                width: cWidth,
                                color: primaryColor,
                                //  Colors.pink,
                                child: Marquee(
                                  text:
                                      'Highest: ${widget.user[highestIndex].teamCode} ( $highest pts )  |  Lowest: ${widget.user[lowestIndex].teamCode} ( $lowest pts )  |  Average: $average  |',
                                  style: kSecondaryTextStyle.copyWith(
                                    color: Colors.white,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  blankSpace: 20.0,
                                  velocity: 50.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  confirmAlert(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Confirm Reset',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Are You Sure You Want To Reset The Scores For ${widget.teamCode}?",
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                onPressed: () => {
                  _onRefresh(),
                  Navigator.pop(context),
                },
              ),
              FlatButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}

class CriteriaListItems extends StatefulWidget {
  var saveData;
  var notify;
  var score;
  CriteriaListItems({
    @required this.notify,
    this.score,
    this.saveData,
  });
  @override
  _CriteriaListItemsState createState() => _CriteriaListItemsState();
}

class _CriteriaListItemsState extends State<CriteriaListItems> {
  final double gapHeight = 0;
  returnValue(int index, value) {
    setState(() {
      // // print("value can be only $value");
      widget.score[index] = value?.toInt() ?? 0;
    });
    widget.notify();
  }

  // highliter

  _showHighlighter() async {
    bool newUser = await getJudgeFirst() ?? true;
    if (newUser) {
      Timer(Duration(seconds: 1), () => showTutorial());
    }
    Timer(
        Duration(seconds: 5),
        () async =>
            (skills?.length ?? 0) > 0 ? await saveJudgeFirst(false) : null);
  }

  GlobalKey judgeKeyHere = GlobalKey();
  List<TargetFocus> targets = List();

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
        keyTarget: judgeKeyHere,
        contents: [
          ContentTarget(
            align: AlignContent.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hold and drag the emoji",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "",
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

// highlighter
  @override
  void initState() {
    super.initState();

    addTarget();

    _showHighlighter();
  }

  @override
  Widget build(BuildContext context) {
    // print("skill length: ${skills}");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: skills?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        // var id = skills[index]["id"];
        var name = skills[index].name;
        double _maxValue = skills[index]?.maxScore?.toDouble() ?? 0.0;

        GlobalKey _tutKey = index == 0 ? judgeKeyHere : null;
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            // color: Colors.red,
                            width: cWidth * 0.72,
                            child: Text(
                              name ?? "",
                              style: kPrimaryTextStyle,
                            ),
                          ),
                          Spacer(),
                          Text(
                            widget.score[index].toString() ?? "kl",
                            style: kPrimaryTextStyle,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: gapHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        key: _tutKey,
                        children: <Widget>[
                          Expanded(
                            child: JudgeSlider(
                              saveData: widget.saveData,
                              return_value: returnValue,
                              index: index,
                              maxValue: _maxValue,
                              initialValue: double.parse(
                                widget.score[index].toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LargeButton extends StatelessWidget {
  final Color color;
  final String btnTxt;
  final TextStyle style;
  final double horizontalPadding;
  final double verticalPadding;
  final Function function;

  LargeButton({
    this.color,
    this.btnTxt,
    this.style,
    this.horizontalPadding,
    this.verticalPadding,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      onPressed: function,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Text(
          btnTxt,
          style: style,
        ),
      ),
    );
  }
}
