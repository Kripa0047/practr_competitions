import 'package:shared_preferences/shared_preferences.dart';

getIds() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getStringList("id");
}

getIdData(String id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return [
    preferences.getStringList("skill$id"),
    preferences.getString("mesg$id"),
    preferences.getInt("totalScore$id"),
  ];
}

getTotalScore(String id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getInt("totalScore$id");
}

getJudgeFirst() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getBool('newJudge');
}

getOrgPresent() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getBool('orgPresent');
}

getJudgeNameData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return [
    preferences.getString('judgeNameS'),
    preferences.getString('judgeUniqueIdS'),
    preferences.getString('judgeKeyS'),
  ];
}

getOrgData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return [
    preferences.getString('uid'),
    preferences.getString('orgCompId'),
    preferences.getString('orgCompName'),
  ];
}

getNewUser() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getBool('newUser');
}

getFirstPartici() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getBool('firstPartici');
}
