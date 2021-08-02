import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/modals/masterSheet.dart';

shareMasterSheet() async {
  var _database = FirebaseDatabase.instance.reference();
  DataSnapshot data;

  data = await _database.child('participants/$orgCompetetionId').once();

  DataSnapshot task = await _database
      .child('task')
      .orderByChild('competetionId')
      .equalTo(orgCompetetionId)
      .once();

  Iterable<dynamic> keyHere = data.value.keys;
  List<String> keys = keyHere.map((key) => key.toString()).toList();

  // task

  Iterable<dynamic> taskKeyHere = task.value.keys;
  List<String> taskKeys = taskKeyHere.map((key) => key.toString()).toList();

// Master csv create

  List<MasterSheet> master = List();

  for (int i = 0; i < keys.length; i++) {
    // print("keys is---------------: ${keys[i]}");
    var dataHere = data.value[keys[i]];
    // print("dataHere is---------------: $dataHere");

    List<double> score = List.filled(
      taskKeys?.length ?? 0,
      0.0,
      growable: true,
    );
    double allTotal = 0.0;
    // print(dataHere);
    List<Average> average = List();
    for (int j = 0; j < taskKeys?.length; j++) {
      // print("value dataHere data is---------------: ${dataHere['data']}");
      Map<dynamic, dynamic> r = dataHere['data'][taskKeys[j]];
      // dataHere['data'][task.value[taskKeys[j]]['name']];
      var total = 0;
      // print("value task.value is---------------: ${task.value[taskKeys[j]]}");
      // print("value taskKeys---------------: ${taskKeys[j]}");

      // print("value is r---------------: $r");
      r?.forEach((key, value) {
        // print("key ${task.value[taskKeys[j]]['name']} is: $key");
        // print("value is score---------------: $value");
        total += (value['score'] ?? 0);
      });
      score[j] = total *
          (task.value[taskKeys[j]]['weightage'] / (100 * (r?.length ?? 1))) *
          1.0; // multiply with weightage;
      // print("total score to be adding is: $total");
      average.add(
        Average(
          name: task.value[taskKeys[j]]['name'] +
              '(${task.value[taskKeys[j]]['weightage'] / (100)})',
          score: score[j],
        ),
      );
      allTotal += score[j];
      // print("new line here\n\n\n");

      // Iterable<dynamic> rKeyHere = r.value.keys;
      // List<String> rKeys = r.map((key) => key.toString()).toList();
      // print("r is: ${r.runtimeType}\n ${rKeys[0]}");
    }
    master.add(MasterSheet(
      teamCode: dataHere['code'],
      average: average,
      total: allTotal,
    ));
  }

  getCsv(
    master,
    orgCompetetionName + ' master score sheet',
    'judge',
  );
}

getCsv(
  List<MasterSheet> associateList,
  String fileName,
  String type,
) async {
  //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

  List<List<dynamic>> rows = List<List<dynamic>>();

  for (int i = 0; i < 1; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add('Team Code');
    for (int j = 0; j < associateList[i].average.length; j++) {
      row.add(associateList[i].average[j].name);
    }
    row.add('Total');
    rows.add(row);
  }
  for (int i = 0; i < associateList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add(associateList[i].teamCode);
    for (int j = 0; j < associateList[i].average.length; j++) {
      row.add(associateList[i].average[j].score);
    }
    row.add(associateList[i].total);
    rows.add(row);
  }

// convert rows to String and write as csv file

  String csv = const ListToCsvConverter().convert(rows);
  shareCsv(csv, fileName);
}

shareCsv(String csv, String name) async {
  await Share.file(
    name + '.csv',
    name + '.csv',
    csv.codeUnits,
    '*/*',
  );
}
