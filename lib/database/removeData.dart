import 'package:shared_preferences/shared_preferences.dart';

removeOrgData() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences?.remove('uid');
  preferences?.remove('orgCompId');
  preferences?.remove('orgCompName');
}
