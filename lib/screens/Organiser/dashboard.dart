import 'dart:async';
import 'dart:math';

import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/common/fancy_dialog_edit.dart';
import 'package:practrCompetitions/modals/judgeModal.dart';
import 'package:practrCompetitions/modals/roundModal.dart';
import 'package:practrCompetitions/modals/teamModal.dart';
import 'package:practrCompetitions/screens/Organiser/bottomsheet/dashBottomSheet.dart';
import 'package:practrCompetitions/screens/Organiser/round/createRound.dart';
import 'package:practrCompetitions/screens/Organiser/share/checkPayment.dart';
import 'package:practrCompetitions/screens/Organiser/share/shareScoresheet.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'emptyState/emptyOrg.dart';

// var _data;
// List<String> _keys;
bool shareAvailable = false;

class OrganiserDashboard extends StatefulWidget {
  List<RoundModal> roundList;
  List<TeamModal> particiList;
  bool loading;
  OrganiserDashboard({
    @required this.roundList,
    @required this.particiList,
    @required this.loading,
    Key key,
  }) : super(key: key);
  @override
  _OrganiserDashboardState createState() => _OrganiserDashboardState();
}

class _OrganiserDashboardState extends State<OrganiserDashboard> {
  //bool _isEmailVerified = false;

  @override
  Widget build(BuildContext context) {
    String competitionName = orgCompetetionName;
    double _height = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            widget.loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Positioned(
                    top: 10,
                    child: Container(
                      width: cWidth,
                      height: cHeight * 0.92,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: _height / 7,
                          bottom: _height / 9,
                        ),
                        child: Container(
                          height: cHeight,
                          width: cWidth,
                          // padding: EdgeInsets.all(16),
                          child: PageViewStyle(
                            roundList: widget.roundList,
                            particiList: widget.particiList,
                          ),
                        ),
                      ),
                    ),
                  ),
            Positioned(
              left: 16,
              top: 16,
              width: cWidth / 1.12,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Rounds",
                          style: kPrimaryTextStyle.copyWith(fontSize: 36),
                        ),
                        Container(
                          width: cWidth * 0.7,
                          child: Text(
                            competitionName ?? "competetion Name",
                            style: kPrimaryTextStyle.copyWith(
                              fontSize: cWidth / 25,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.ellipsisH,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        showOptionBottomSheet(
                          context,
                          shareAvailable,
                          widget.particiList,
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageViewStyle extends StatefulWidget {
  List<RoundModal> roundList;
  var particiList;
  PageViewStyle({
    @required this.roundList,
    @required this.particiList,
  });
  @override
  _PageViewStyleState createState() => _PageViewStyleState();
}

class _PageViewStyleState extends State<PageViewStyle> {
  final controller = PageController(
    // initialPage: 1,
    viewportFraction: 0.85,
  );
  int currentPage = 0;
  bool listnerOn = false;
  @override
  void initState() {
    super.initState();
    print("this currentIndexcurrentIndex0000000 $currentPage");
    if (!listnerOn) {
      pageListner();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool controllerActive = false;
  pageListner() {
    listnerOn = true;
    print("pageListner active0.");

    controller.addListener(() {
      int next = controller?.page?.round() ?? 0;
      controllerActive = true;
      print("next $next");
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // currentPage
    if (!listnerOn) {
      pageListner();
    }

    print("controllerActive: $controllerActive");
    // print("position: ${controller.offset.round()}");
    int _len = widget.roundList?.length ?? 0;
    return Container(
      child: _len == 0
          ? emptyRound()
          : PageView.builder(
              controller: controller,
              itemCount: _len,
              itemBuilder: (context, int currentIndex) {
                print("position: ${controller.offset.round()}");
                if (!controllerActive) {
                  int _page = ((controller?.offset ?? 1) - 1) ~/ 180;

                  print("_page: $_page");
                  print("current Page0: $currentPage");
                  _page = _page ?? 1;
                  _page -= 1;
                  if (_page != currentPage) {
                    currentPage = _page;
                  }
                  if (currentPage < 0 || currentPage >= _len) {
                    currentPage = 0;
                  }
                  print("current Page: $currentPage");
                }

                bool active = currentIndex == currentPage;
                return _buildPage(
                  active,
                  currentIndex,
                );
              },
            ),
    );
  }

  _buildPage(
    bool active,
    int index,
  ) {
    // final double blur = active ? 30 : 0;
    // final double offset = active ? 15 : 0;
    final double top = active ? 0 : 30;
    final double bottom = active ? 0 : 30;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: top,
        bottom: bottom,
        // right: 30,
      ),
      child: listItem(index),
    );
  }

  Widget listItem(int index) {
    // widget.data =widget. data[widget.keys[index]];
    String _key = widget.roundList[index].key;
    return Container(
      width: cWidth / 1.2,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Card(
        // color: Colors.green,
        child: RoundCard(
          key: PageStorageKey(_key),
          roundIndex: index,
          roundData: widget.roundList,
          particiList: widget.particiList,
          isRoundDraft: widget.roundList[index].live == 0 ? true : false,
        ),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class RoundCard extends StatefulWidget {
  int roundIndex;
  var roundData;
  var particiList;
  var isRoundDraft;
  RoundCard({
    Key key,
    @required this.roundIndex,
    @required this.roundData,
    @required this.particiList,
    @required this.isRoundDraft,
  }) : super(key: key);
  @override
  _RoundCardState createState() => _RoundCardState();
}

class _RoundCardState extends State<RoundCard> {
  bool isOptionsSelected = false;
  bool _isLoading = true;
  String _roundId = '';

  List<JudgeModal> _judgeList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onJudgeModalAddedSubscription;
  StreamSubscription<Event> _onJudgeModalValueSubscription;

  StreamSubscription<Event> _onJudgeModalChangedSubscription;
  StreamSubscription<Event> _onJudgeModalRemovedSubscription;
  Query _judgeQuery;

  //bool _isEmailVerified = false;
  StreamSubscription<Event> _onResultModalAddedSubscription;

  @override
  void initState() {
    super.initState();
    // load judge
    String secretCode = widget.roundData[widget.roundIndex].secretCode;
    _judgeList = new List();
    if (!widget.isRoundDraft) {
      _judgeQuery = _database
          .reference()
          .child('judges')
          .orderByChild("taskSecret")
          .equalTo(secretCode);
      _onJudgeModalValueSubscription =
          _judgeQuery.onValue.listen(onEntryPresent);
      _onJudgeModalAddedSubscription =
          _judgeQuery.onChildAdded.listen(onEntryAdded);
      _onJudgeModalChangedSubscription =
          _judgeQuery.onChildChanged.listen(onEntryChanged);
      _onJudgeModalRemovedSubscription =
          _judgeQuery.onChildRemoved.listen(onEntryRemoved);
    } else {
      _isLoading = false;
    }
    submitted = 0;
  }

  @override
  void dispose() {
    _onJudgeModalAddedSubscription?.cancel();
    _onJudgeModalChangedSubscription?.cancel();
    _onResultModalAddedSubscription?.cancel();
    _onJudgeModalValueSubscription?.cancel();

    super.dispose();
  }

  onEntryRemoved(Event event) {
    var oldEntry = _judgeList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      var index = _judgeList.indexOf(oldEntry);

      if (!_judgeDeleting[index]) {
        _judgeList.removeAt(index);
        _judgeDeleting.removeAt(index);
      }

      // _judgeList.remove(
      //   TeamModal.fromSnapshot(event.snapshot),
      // );
    });
  }

  onEntryPresent(Event event) {
    // print("on entry present: -------000000111112221111000000--------");
    _onJudgeModalValueSubscription?.cancel();
    setState(() {
      _isLoading = false;
    });
  }

  onEntryChanged(Event event) {
    var oldEntry = _judgeList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _judgeList[_judgeList.indexOf(oldEntry)] =
          JudgeModal.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _judgeList.add(JudgeModal.fromSnapshot(event.snapshot));
      _judgeDeleting.add(false);
      _isLoading = false;
    });
  }

  int submitted = 0;
  String roundName = '';
  @override
  Widget build(BuildContext context) {
    bool isDraft = widget.roundData[widget.roundIndex].live == 0 ? true : false;

    roundName = widget.roundData[widget.roundIndex].name;
    _roundId = widget.roundData[widget.roundIndex].taskId;

    submitted = 0;
    shareAvailable = false;
    for (int i = 0; i < _judgeList.length; i++) {
      if (_judgeList[i].completed) {
        submitted++;
        shareAvailable = true;
      }
    }
    // print("sValue is: ${widget.sValue} \nLive: ${widget.sValue["Live"]}");
    // print("roundName: $roundName\nsecretCode: $secretCode");

    return judgeItem(
      isDraft,
      roundName,
    );
  }

  List<bool> _judgeDeleting = List();
  // String judgeUniqueIdHereDelete;
  // String judgeKeyDelete;
  _deleteJudge(
    BuildContext context,
    int index,
    bool _isCompleted,
  ) async {
    setState(() {
      _judgeDeleting[index] = true;
    });
    String judgeKeyDelete = _judgeList[index].key;
    String judgeUniqueIdHereDelete = _judgeList[index].uniqueId;
    try {
      print(
          "deleting judge _isCompleted: $_isCompleted judgeKeyDelete: $judgeKeyDelete");

      await FirebaseDatabase.instance
          .reference()
          .child('judges/$judgeKeyDelete')
          .remove();

      if (_isCompleted) {
        var _resultQuery = FirebaseDatabase.instance
            .reference()
            .child('result/$orgCompetetionId/$_roundId')
            .orderByChild('judgeUniqueId')
            .equalTo(judgeUniqueIdHereDelete);

        print("result query");

        _onEntryAdded(Event event) {
          print('result _onEntryAdded query is: ${event.snapshot.key}');
          String _key = event.snapshot.key;
          FirebaseDatabase.instance
              .reference()
              .child('result/$orgCompetetionId/$_roundId')
              .child(_key)
              .remove();
        }

        _onResultModalAddedSubscription =
            _resultQuery.onChildAdded.listen(_onEntryAdded);

        for (var item in widget.particiList) {
          print("item is: ${item.participantId}");
          var userId = item?.participantId;

          DataSnapshot _data = await FirebaseDatabase.instance
              .reference()
              .child('participants/$orgCompetetionId/$userId/data/$_roundId/')
              .orderByChild('uniqueId')
              .equalTo(judgeUniqueIdHereDelete)
              .once();
          print(
              "orgCompetetionId: $orgCompetetionId \nuserId: $userId\nroundName: $roundName");
          print(
              "judgeUniqueIdHereDelete: $judgeUniqueIdHereDelete\n_data: $_data\n_data value: ${_data.value}\nKey: ${_data.key}\nType: ${_data.value.runtimeType}");

          Iterable<dynamic> keyHere = _data?.value?.keys;
          List<String> keys =
              keyHere?.map((key) => key.toString())?.toList() ?? [];

          // for (var key in keys) {
          // print("key is: $key");
          try {
            await FirebaseDatabase.instance
                .reference()
                .child('participants/$orgCompetetionId/$userId/data/$_roundId/')
                .child(keys[0])
                .remove();
          } catch (e) {
            errorDialog(
              context,
              'Try Again!',
              'Error connecting to server.',
            );
          }
          // }
        }
      }
      setState(() {
        _judgeList.removeAt(index);
        _judgeDeleting.removeAt(index);
      });
      print("judge list length: ${_judgeList.length}");
    } catch (e) {
      print("it is error $e");

      errorDialog(
        context,
        "Try Again!",
        "Error deleting the judge: $e",
      );
    }
    setState(() {
      if (index < _judgeDeleting.length) {
        _judgeDeleting[index] = false;
      }
    });
  }

  bool _sharingScoresheet = false;
  judgeItem(
    bool isDraft,
    String roundName,
  ) {
    String secretCode =
        widget.roundData[widget.roundIndex]?.secretCode ?? "Not Found!!";

    String status = "Still Judging";

    bool showLine = (_judgeList?.length ?? 0) == 0 ? false : true;
    // print("showLine here: $showLine");
    double dPercent = 0.0;
    int percent = 0;
    if (showLine) {
      dPercent = ((submitted / (_judgeList?.length ?? 1)) * 100);
      if (dPercent.isNaN || dPercent.isInfinite) {
        percent = 0;
      } else {
        percent = dPercent.toInt();
      }
    }
    bool _isCompleted = true;
    // print("_judgeList_judgeList:${_judgeList.length} $isDraft");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: Colors.red,
      ),
      height: cHeight,
      width: cWidth,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateRound(
                      roundList: widget.roundData,
                      data: widget.roundData[widget.roundIndex],
                      firstTime: false,
                      taskIdHere: _roundId,
                      canChange: submitted > 0 ? false : true,
                    ),
                  ),
                );
              },
              child: Card(
                child: (_judgeList?.length ?? 0) == 0
                    ? ListView(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(24, 32, 8, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  isDraft ? "Draft" : "Live",
                                  style: kSecondaryTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: cWidth / 25),
                                ),
                                Container(
                                  width: cWidth * 0.5,
                                  child: Text(
                                    roundName ?? "Loading...",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kPrimaryTextStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: cWidth / 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _isLoading
                              ? Container(
                                  // color: Colors.green,
                                  height: cHeight * 0.4,
                                  // width: cWidth,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  ),
                                )
                              : isDraft
                                  ? Container(
                                      // height: cHeight * 0.3,
                                      padding:
                                          EdgeInsets.only(top: cHeight * 0.092),
                                      // color: Colors.red,
                                      child: emptyDraftJudge(),
                                    )
                                  : emptyLiveJudge()
                        ],
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(24, 32, 8, 0),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    isDraft ? "Draft" : "Live",
                                    style: kSecondaryTextStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: cWidth / 25),
                                  ),
                                  Container(
                                    width: cWidth * 0.5,
                                    child: Text(
                                      roundName ?? "Loading...",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: kPrimaryTextStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: cWidth / 15),
                                    ),
                                  )
                                ],
                              ),
                              isDraft || !showLine
                                  ? Container()
                                  : Transform.rotate(
                                      angle: isOptionsSelected
                                          ? 0.0000001
                                          : pi / 2,
                                      child: IconButton(
                                        icon: Icon(
                                          isOptionsSelected
                                              ? Icons.arrow_back
                                              : FontAwesomeIcons.ellipsisH,
                                          size: cWidth / 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isOptionsSelected =
                                                !isOptionsSelected;
                                          });
                                        },
                                      ),
                                    )
                            ],
                          ),
                          !showLine
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: isDraft
                                      ? Container()
                                      : Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: LinearPercentIndicator(
                                                backgroundColor: Colors.white,
                                                lineHeight: 7,
                                                animation: true,
                                                animationDuration: 2000,
                                                percent: dPercent / 100,
                                                linearStrokeCap:
                                                    LinearStrokeCap.roundAll,
                                                progressColor: Colors.yellow,
                                              ),
                                            ),
                                            Text(
                                              percent.toString() + '%',
                                              style:
                                                  kSecondaryTextStyle.copyWith(
                                                      color: Colors.white,
                                                      fontSize: cWidth / 25),
                                            )
                                          ],
                                        ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: ListView.builder(
                                itemCount: _judgeList?.length ?? 0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  String judgeName = _judgeList[index].name;
                                  String first =
                                      judgeName.substring(0, 1).toUpperCase();
                                  judgeName = first + judgeName.substring(1);

                                  _isCompleted = _judgeList[index].completed;
                                  var _icon;
                                  if (_isCompleted) {
                                    status = "Completed";
                                    _icon = FontAwesomeIcons.checkCircle;
                                  } else {
                                    status = 'Still Judging';
                                    _icon = FontAwesomeIcons.edit;
                                  }
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    color: Colors.black.withOpacity(0.1),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text(
                                          first ?? "Y",
                                          style: kPrimaryTextStyle,
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                      trailing: _judgeDeleting[index]
                                          ? IconButton(
                                              onPressed: () {},
                                              icon: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.white),
                                              ),
                                            )
                                          : isOptionsSelected
                                              ? IconButton(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding: EdgeInsets.all(0),
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () => showDialog(
                                                    context: context,
                                                    // barrierDismissible: false,
                                                    builder: (_) => FancyDialog(
                                                      title: deleteJudgeHeader,
                                                      animationType:
                                                          FancyAnimation
                                                              .TOP_BOTTOM,
                                                      descreption:
                                                          deleteJudgeBody,
                                                      okFun: () => _deleteJudge(
                                                        context,
                                                        index,
                                                        _judgeList[index]
                                                                ?.completed ??
                                                            false,
                                                      ),
                                                      okColor: primaryColor,
                                                      ok: 'Confirm',
                                                    ),
                                                  ),
                                                )
                                              : Icon(
                                                  _icon,
                                                  // checkCircle,
                                                  color: Colors.white,
                                                ),
                                      title: Text(
                                        judgeName ?? "Naveen",
                                        style: kSecondaryTextStyle.copyWith(
                                          color: Colors.white,
                                          fontSize: cWidth / 25,
                                        ),
                                      ),
                                      subtitle: Text(
                                        status,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: cWidth / 35),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                elevation: 3,
                color: isDraft ? Colors.grey : Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.zero,
              ),
            ),
          ),
          isDraft
              ? Container()
              : Expanded(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: CardButtons(
                              width: cWidth,
                              buttonTextOne: "INVITE",
                              buttonTextTwo: "JUDGES",
                              onTap: () {
                                copyDialog(
                                  context,
                                  "Success",
                                  'Share this code (case sensitive) with your judges to begin scoring process',
                                  secretCode,
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Colors.grey,
                          // primaryColor,
                        ),
                        Expanded(
                          child: _sharingScoresheet
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CardButtons(
                                  width: cWidth,
                                  buttonTextOne: "SHARE",
                                  buttonTextTwo: "SCORESHEET",
                                  color: submitted > 0
                                      ? primaryColor
                                      : Colors.grey,
                                  onTap: !(submitted > 0)
                                      ? null
                                      : () async {
                                          print("sharing scoresheet");
                                          setState(() {
                                            _sharingScoresheet = true;
                                          });
                                          bool paid = false;
                                          paid = await checkPayment(context);
                                          if (paid) {
                                            await shareScoreSheet(
                                              roundName,
                                              _roundId,
                                              secretCode,
                                            );
                                          }
                                          setState(() {
                                            _sharingScoresheet = false;
                                          });
                                        },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class CardButtons extends StatelessWidget {
  final String buttonTextOne;
  final String buttonTextTwo;
  final double width;
  final Function onTap;
  final Color color;

  CardButtons({
    this.width,
    this.buttonTextOne,
    this.buttonTextTwo,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              buttonTextOne,
              style: kSecondaryTextStyle.copyWith(
                fontSize: width / 25,
                color: color,
              ),
            ),
            Text(
              buttonTextTwo,
              style: kPrimaryTextStyle.copyWith(
                fontSize: width / 20,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
