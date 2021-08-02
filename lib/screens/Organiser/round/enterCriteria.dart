import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/modals/orgSkill.dart';
import 'package:practrCompetitions/utils/styles.dart';

class EnterCriteria extends StatelessWidget {
  TextEditingController controller;
  List<OrgSkill> skills;
  bool host;
  int totalPoint;
  Function notify;
  EnterCriteria({
    @required this.controller,
    @required this.skills,
    @required this.host,
    @required this.totalPoint,
    @required this.notify,
  });
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "back",
                      style: kPrimaryTextStyle,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      if (skills
                          .any((skill) => skill.name == controller.text)) {
                        errorDialog(
                          context,
                          "Already Exist",
                          "Criteria Already exist!",
                        );
                      } else if (controller.text == '') {
                        Navigator.pop(context);
                      } else {
                        skills.add(
                          OrgSkill(
                            maxScore: 10,
                            name: controller.text,
                          ),
                        );
                        host = true;
                        controller?.clear();
                        totalPoint += 10;
                        notify(totalPoint);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "done",
                      style: kPrimaryTextStyle,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 8,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: "Enter Judgement Criteria",
                ),
                style: kPrimaryTextStyle.copyWith(fontSize: _width / 10),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
