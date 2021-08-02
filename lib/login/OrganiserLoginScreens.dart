import 'package:flutter/material.dart';
import 'package:practrCompetitions/Lang/English.dart';
import 'package:practrCompetitions/utils/widgets.dart';

final TextEditingController organiserNameController = TextEditingController();

class OrganiserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleFieldForm(
      title: "Let\'s begin!\nWhat\'s your name?",
      hintText: "Name",
      labelText: "name",
      routerString: "compName",
      bottomWidget: Container(),
      inputLeadingWidget: Container(),
      controller: organiserNameController,
      pushNamedAndRemoveUntil: true,
      type: 'org',
      textCapitalization: TextCapitalization.sentences,
    );
  }
}

final TextEditingController competitionNameController = TextEditingController();

class CompetitionName extends StatefulWidget {
  @override
  _CompetitionNameState createState() => _CompetitionNameState();
}

class _CompetitionNameState extends State<CompetitionName> {
  @override
  void initState() {
    super.initState();
    competitionNameController?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleFieldForm(
      title: enterCompName,
      hintText: hintCompName,
      labelText: labelCompName,
      routerString: "orgHome",
      bottomWidget: Container(),
      inputLeadingWidget: Container(),
      controller: competitionNameController,
      pushNamedAndRemoveUntil: true,
      type: 'comp',
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
