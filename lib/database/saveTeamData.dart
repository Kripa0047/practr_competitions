import 'package:shared_preferences/shared_preferences.dart';

saveIds(List<String> id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setStringList("id", id);
}

saveData(
  String id,
  List<String> skill,
  String mesg,
  int totalScore,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setStringList("skill$id", skill);
  await preferences.setString("mesg$id", mesg);
  await preferences.setInt("totalScore$id", totalScore);
}

saveOrgPresent(bool present) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setBool('orgPresent', present);
}

saveJudgeNameData(
  String judgeNameS,
  String judgeUniqueIdS,
  String judgeKeyS,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString('judgeNameS', judgeNameS);
  await preferences.setString('judgeUniqueIdS', judgeUniqueIdS);
  await preferences.setString('judgeKeyS', judgeKeyS);
}

saveJudgeFirst(
  bool newJudge,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setBool('newJudge', newJudge);
}

saveOrgData(
  String uid,
  String orgCompId,
  String orgCompName,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString('uid', uid);
  await preferences.setString('orgCompId', orgCompId);
  await preferences.setString('orgCompName', orgCompName);
}

saveNewUser(
  bool newUser,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setBool('newUser', newUser);
}
saveFirstPartici(
  bool firstPartici,
) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setBool('firstPartici', firstPartici);
}
