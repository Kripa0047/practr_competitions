import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/login/function.dart';
import 'package:practrCompetitions/modals/roundModal.dart';
import 'package:practrCompetitions/modals/teamModal.dart';
import 'package:practrCompetitions/screens/Organiser/dashboard.dart';
import 'package:practrCompetitions/screens/Organiser/participant/participants.dart';
import 'package:practrCompetitions/screens/Organiser/round/createRound.dart';
import 'package:practrCompetitions/utils/styles.dart';

class OrganiserHome extends StatefulWidget {
  OrganiserHome({Key key}) : super(key: key);

  @override
  _OrganiserHomeState createState() => _OrganiserHomeState();
}

class _OrganiserHomeState extends State<OrganiserHome>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool multipleCompetitions = false;

  List<TeamModal> _particiList;
  Query _particiQuery;
  Query _roundQuery;
  List<RoundModal> _roundList;
  bool _isLoading1 = true;
  bool _isLoading2 = true;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onParticiModalAddedSubscription;
  StreamSubscription<Event> _onParticiModalChangedSubscription;
  StreamSubscription<Event> _onParticiValueChangedSubscription;

  StreamSubscription<Event> _onRoundModalAddedSubscription;
  StreamSubscription<Event> _onRoundModalChangedSubscription;
  StreamSubscription<Event> _onRoundValueChangedSubscription;

  //bool _isEmailVerified = false;
  List<Widget> _tabList = List();

  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

    _particiList = new List();
    if (_particiQuery == null) {
      print("participation query: $_particiQuery");
      _particiQuery = _database
          .reference()
          .child('participants/$orgCompetetionId')
          .orderByChild("competetionId")
          .equalTo(orgCompetetionId);
    }
    _onParticiModalAddedSubscription =
        _particiQuery.onChildAdded.listen(onParticiEntryAdded);
    _onParticiModalChangedSubscription =
        _particiQuery.onChildChanged.listen(onParticiEntryChanged);
    _onParticiValueChangedSubscription =
        _particiQuery.onValue.listen(onParticiValueChanged);

    _roundList = new List();
    if (_roundQuery == null) {
      print("round query: $_roundQuery");

      _roundQuery = _database
          .reference()
          .child("task")
          .orderByChild("competetionId")
          .equalTo(orgCompetetionId);
    }

    _onRoundModalAddedSubscription =
        _roundQuery.onChildAdded.listen(onRoundEntryAdded);
    _onRoundModalChangedSubscription =
        _roundQuery.onChildChanged.listen(onRoundEntryChanged);
    _onRoundValueChangedSubscription =
        _roundQuery.onValue.listen(onRoundValueChanged);

    _tabList = [
      OrganiserDashboard(
        roundList: _roundList,
        particiList: _particiList,
        loading: _isLoading2,
        key: PageStorageKey('Page1'),
      ),
      Participants(
        roundList: _roundList,
        particiList: _particiList,
        loading: _isLoading1,
        key: PageStorageKey('Page2'),
      ),
    ];

    _tabController = TabController(
      vsync: this,
      length: _tabList.length,
    );
    checkCompFunc();
  }

  checkCompFunc() async {
    bool _competitionPresent = await checkCompetetion();
    if (!_competitionPresent) {
      // print(
      //     "_competition not present revert back to 1. no internet 2. competition changed.");
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/orgPhone',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    _onParticiModalAddedSubscription?.cancel();
    _onParticiModalChangedSubscription?.cancel();
    _onParticiValueChangedSubscription?.cancel();

    _onRoundModalAddedSubscription?.cancel();
    _onRoundModalChangedSubscription?.cancel();
    _onRoundValueChangedSubscription?.cancel();
    _tabController?.dispose();
    super.dispose();
  }

  onParticiEntryChanged(Event event) {
    var oldEntry = _particiList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _particiList[_particiList.indexOf(oldEntry)] =
          TeamModal.fromSnapshot(event.snapshot);
    });

    print('paricipant changed');
  }

  onParticiEntryAdded(Event event) {
    setState(() {
      _particiList.add(TeamModal.fromSnapshot(event.snapshot));
    });
    print('paricipant added');
  }

  onParticiValueChanged(Event event) {
    if (_isLoading1) {
      setState(() {
        _isLoading1 = false;
      });

      _onParticiValueChangedSubscription?.cancel();
    }
  }

  onRoundEntryChanged(Event event) {
    var oldEntry = _roundList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _roundList[_roundList.indexOf(oldEntry)] =
          RoundModal.fromSnapshot(event.snapshot);
    });
  }

  onRoundEntryAdded(Event event) {
    setState(() {
      _roundList.add(RoundModal.fromSnapshot(event.snapshot));
    });
  }

  onRoundValueChanged(Event event) {
    if (_isLoading2) {
      setState(() {
        _isLoading2 = false;
      });

      _onRoundValueChangedSubscription?.cancel();
    }
  }

  TabController _tabController;

  Widget _bottomNavigationBar() => BottomNavigationBar(
        backgroundColor: _currentIndex == 0 ? Colors.pink : primaryColor,
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                color: _currentIndex == 0
                    ? Colors.yellow
                    : Colors.yellow.withOpacity(0.5),
              ),
              title: Text(
                "Rounds",
                style: kPrimaryTextStyle.copyWith(
                  color: _currentIndex == 1 ? Colors.grey : Colors.white,
                  fontSize:
                      _currentIndex == 1 ? cWidth * 0.042 : cWidth * 0.045,
                ),
              ),
              backgroundColor: Colors.pink),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 1
                  ? FontAwesomeIcons.userAlt
                  : FontAwesomeIcons.user,
              color: _currentIndex == 1
                  ? Colors.yellow
                  : Colors.yellow.withOpacity(0.5),
            ),
            title: Text(
              "Participants",
              style: kPrimaryTextStyle.copyWith(
                color: _currentIndex == 0 ? Colors.grey : Colors.white,
                fontSize: _currentIndex == 0 ? cWidth * 0.042 : cWidth * 0.045,
              ),
            ),
          ),
        ],
      );

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'homeTag',
        child: Icon(_currentIndex == 1 ? Icons.group_add : Icons.add),
        backgroundColor: _currentIndex == 0 ? Colors.pink : primaryColor,
        onPressed: _currentIndex == 0
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateRound(
                      roundList: _roundList,
                    ),
                  ),
                );
              }
            : () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EnterParticipantCode(
                      particiList: _particiList,
                    ),
                  ),
                );
              },
      ),
      bottomNavigationBar: _bottomAppBar(),
      // _bottomNavigationBar(),
      body: PageStorage(
        child: _currentIndex == 0
            ? OrganiserDashboard(
                roundList: _roundList,
                particiList: _particiList,
                loading: _isLoading2,
                key: PageStorageKey('Page1'),
              )
            : Participants(
                roundList: _roundList,
                particiList: _particiList,
                loading: _isLoading1,
                key: PageStorageKey('Page2'),
              ),
        bucket: bucket,
      ),
    );
  }

  _bottomAppBar() {
    return BottomAppBar(
      color: _currentIndex == 0 ? Colors.pink : primaryColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
//            color: Colors.red,
            child: Row(
              children: <Widget>[
                Icon(
                  _currentIndex == 0
                      ? FontAwesomeIcons.solidStar
                      : FontAwesomeIcons.star,
                  color: _currentIndex == 0
                      ? Colors.yellow
                      : Colors.yellow.withOpacity(0.5),
                ),
                Text(
                  "  Rounds",
                  style: kPrimaryTextStyle.copyWith(
                    color: _currentIndex == 1 ? Colors.grey : Colors.white,
                    fontSize:
                        _currentIndex == 1 ? cWidth * 0.042 : cWidth * 0.045,
                  ),
                ),
//                SizedBox(
//                  width: 8,
//                ),
              ],
            ),
          ),
          FlatButton(
//            color: Colors.green,
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            hoverColor: Colors.transparent,
            child: Row(
              children: <Widget>[
//                SizedBox(
//                  width: 8,
//                ),
                Text(
                  "Participants ",
                  style: kPrimaryTextStyle.copyWith(
                    color: _currentIndex == 0 ? Colors.grey : Colors.white,
                    fontSize:
                        _currentIndex == 0 ? cWidth * 0.042 : cWidth * 0.045,
                  ),
                ),
                Icon(
                  _currentIndex == 1
                      ? FontAwesomeIcons.userAlt
                      : FontAwesomeIcons.user,
                  color: _currentIndex == 1
                      ? Colors.yellow
                      : Colors.yellow.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
