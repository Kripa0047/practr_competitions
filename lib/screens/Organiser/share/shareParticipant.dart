import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:practrCompetitions/modals/particiSheet.dart';

shareParticipantSheet(
  List participant,
  String fileName,
) async {
  await getParticipantCsv(
    participant,
    fileName,
  );
}

getParticipantCsv(
  List<ParticiSheet> associateList,
  String fileName,
) async {
  //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

  List<List<dynamic>> rows = List<List<dynamic>>();

  for (int i = 0; i < 1; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();

    row.add('Round Name');
    row.add('Score');
    rows.add(row);
  }
  for (int i = 0; i < associateList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add(associateList[i].name);
    row.add(associateList[i].score);
    rows.add(row);
  }

// convert rows to String and write as csv file

  String csv = const ListToCsvConverter().convert(rows);
  shareParticipantCsv(csv, fileName);
}

shareParticipantCsv(String csv, String name) async {
  await Share.file(
    name + '.csv',
    name + '.csv',
    csv.codeUnits,
    '*/*',
  );
}
