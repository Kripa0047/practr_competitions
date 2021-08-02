import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/common/common.dart';
import 'package:practrCompetitions/common/connection.dart';
import 'package:practrCompetitions/database/removeData.dart';
import 'package:practrCompetitions/login/OrganiserLoginScreens.dart';
import 'package:practrCompetitions/utils/widgets.dart';

class ConcludeScreen extends StatelessWidget {
  final TextEditingController _submissionController = TextEditingController();

  createLink() async {
    print("link is getting creating.........................");
    // https://under25competitions-d3dee.firebaseapp.com
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://under25competitions-d3dee.firebaseapp.com',
      link: Uri.parse('https://under25competitions-d3dee.firebaseapp.com'),
      androidParameters: AndroidParameters(
        packageName: 'com.under25.competitions',
        minimumVersion: 125,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.example.ios',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Example of a Dynamic Link',
        description: 'This link works whether app is installed or not!',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();
    print('dynamic url is: $dynamicUrl');
  }

  @override
  Widget build(BuildContext context) {
    createLink();
    return SingleFieldForm(
      // pushNamedAndRemoveUntil: true,
      title: "Ready to conclude?",
      labelText: "Type CONCLUDE to confirm",
      hintText: "CONCLUDE",
      bottomWidget: Container(),
      inputLeadingWidget: Container(),
      btnText: "Conclude Competetion",
      routerString: "",
      textCapitalization: TextCapitalization.characters,
      controller: _submissionController,
      type: 'conclude',
      onPressed: () async {
        await FirebaseDatabase.instance
            .reference()
            .child('competetion/$orgCompetetionId')
            .update({'ongoing': false});
        await removeOrgData();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => CompetitionName(),
            ),
            (Route<dynamic> route) => false);
      },
    );
  }
}
