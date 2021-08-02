import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/errorHandling.dart';
import 'package:practrCompetitions/modals/orgSkill.dart';
import 'package:practrCompetitions/utils/styles.dart';

class EditCriteria extends StatefulWidget {
  List<OrgSkill> skills;
  int index;
  String name;
  EditCriteria({
    @required this.skills,
    this.index,
    this.name,
  });

  @override
  _EditCriteriaState createState() => _EditCriteriaState();
}

class _EditCriteriaState extends State<EditCriteria> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.name;
  }

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
                      if ((widget.name == controller.text) ||
                          (controller.text == '')) {
                        Navigator.pop(context);
                      } else if (widget.skills
                          .any((skill) => skill.name == controller.text)) {
                        errorDialog(
                          context,
                          "Already Exist",
                          "Criteria Already exist!",
                        );
                      } else {
                        widget.skills[widget.index].name = controller.text;

                        controller?.clear();
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
