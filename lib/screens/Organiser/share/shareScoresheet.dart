import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/modals/judgeSheet.dart';
import 'package:practrCompetitions/modals/roundSheet.dart';

double weightage = 0;
shareScoreSheet(
  String roundName,
  String roundId,
  String secretCode,
) async {
  var _database = FirebaseDatabase.instance.reference();
  DataSnapshot data = await _database
      .child('result/$orgCompetetionId/$roundId')
      .orderByChild('taskSecret')
      .equalTo(secretCode)
      .once();

  DataSnapshot task = await _database.child('task/$roundId').once();

  Iterable<dynamic> keyHere = data.value.keys;
  List<String> keys = keyHere.map((key) => key.toString()).toList();

// judge csv create
  List csvJudge = List();
  for (int i = 0; i < keys.length; i++) {
    // print("judge$i data: ${data.value[keys[i]]}");
    var dataHere = data.value[keys[i]];
    List<JudgeSheet> judge = List();
    for (int j = 0; j < dataHere["user"]?.length; j++) {
      final List<Criterion> criteriaList = List();

      if (dataHere["user"][j]["skill"] != null) {
        for (var skill in dataHere["user"][j]["skill"]) {
          criteriaList.add(
            Criterion(
              criteria: skill["name"],
              score: skill["score"],
              emoji: skill["emoji"],
            ),
          );
        }
        judge.add(
          JudgeSheet(
            teamCode: dataHere["user"][j]["teamCode"],
            total: dataHere["user"][j]["total"],
            criteria: criteriaList,
          ),
        );
      }
    }
    // String name = 'JUDGE${i + 1}' + dataHere["judgeName"];
    csvJudge.add(judge);
    // getCsv(judge, name, 'judge');
  }
  var judgeFile = await getCsv(
    csvJudge,
    'judge',
    'judge',
  );

//  Round csv create
  weightage = task.value["weightage"] / 100;
  // print("task is: ${task.value["weightage"]}");
  List<RoundSheet> round = List();
  // create almost empty list
  for (int j = 0; j < data.value[keys[0]]["user"]?.length; j++) {
    List<Judge> judge = List();
    for (int i = 0; i < keys.length; i++) {
      judge.add(Judge(name: data.value[keys[i]]["judgeName"]));
    }

    round.add(RoundSheet(
      teamCode: data.value[keys[0]]["user"][j]["teamCode"],
      judge: judge,
    ));
  }
  // fill the score here
  for (int j = 0; j < data.value[keys[0]]["user"]?.length; j++) {
    int total = 0;
    for (int i = 0; i < keys.length; i++) {
      var dataHere = data.value[keys[i]];
      if (dataHere["user"][j]["total"] != null) {
        round[j].judge[i].score = dataHere["user"][j]["total"];
        total += dataHere["user"][j]["total"];
      } else {
        round[j].judge[i].score = 0;
      }
    }
    round[j].total = total;
    round[j].average = total / (keys?.length ?? 1);
    round[j].weightedAverage = round[j].average * weightage;
  }

  var roundFile = await getCsv(
    round,
    'round',
    'round',
  );

  shareMultipleCsv(
    judgeFile,
    roundFile,
    roundName + ' round score sheet', // round name
    roundName + ' judges score sheet' // judges name
    ,
  );
}

getCsv(
  associateList,
  fileName,
  type,
) async {
  //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

  List<List<dynamic>> rows = List<List<dynamic>>();
  if (type == 'judge') {
    List<dynamic> row = List();
    for (int k = 0; k < associateList?.length; k++) {
      for (int i = 0; i < 1; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file

        row.add('Team Code');
        for (int j = 0; j < associateList[k][i].criteria.length; j++) {
          row.add(associateList[k][i].criteria[j].criteria);
        }
        row.add('Total');
        row.add('');
      }
    }
    rows.add(row);
    for (int i = 0; i < associateList[0].length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file

      List<dynamic> row = List();
      for (int k = 0; k < associateList?.length; k++) {
        row.add(associateList[k][i]?.teamCode);
        for (int j = 0; j < associateList[k][i].criteria.length; j++) {
          row.add(associateList[k][i].criteria[j].score);
        }
        row.add(associateList[k][i].total);
        row.add('');
      }
      rows.add(row);
    }
  } else if (type == 'round') {
    for (int i = 0; i < 1; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add('Team Code');
      for (int j = 0; j < associateList[i].judge.length; j++) {
        row.add(associateList[i].judge[j].name);
      }
      row.add('Total');
      row.add('Average');
      row.add('Weighted Average ($weightage)');
      rows.add(row);
    }
    for (int i = 0; i < associateList.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(associateList[i].teamCode);
      for (int j = 0; j < associateList[i].judge.length; j++) {
        row.add(associateList[i].judge[j].score);
      }
      row.add(associateList[i].total);
      row.add(associateList[i].average);
      row.add(associateList[i].weightedAverage);
      rows.add(row);
    }
  }
// convert rows to String and write as csv file

  String csv = const ListToCsvConverter().convert(rows);
  // await shareCsv(csv, fileName);
  return csv;
}

shareMultipleCsv(
  String csv1,
  String csv2,
  String roundFileName,
  String judgeFileName,
) async {
  await Share.files(
    'ScoreSheet.csv',
    {
      '$judgeFileName.csv': csv1.codeUnits,
      '$roundFileName.csv': csv2.codeUnits,
    },
    '*/*',
  );
}
