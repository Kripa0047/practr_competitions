import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

Future<String> getDeviceId() async {
  String uDeviceId;

  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  if (Platform.isIOS) {
    print('is a IOS');
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    uDeviceId = iosInfo.identifierForVendor;
  } else if (Platform.isAndroid) {
    print('is a Andriod');
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    uDeviceId = androidDeviceInfo.androidId;
  }

  return uDeviceId;
}

// generate secreteCode here
secretCodeGenerator() async {
  // final Random _random = Random();

  // String CreateCryptoRandomString([int length = 32]) {
  //   var values = List<int>.generate(length, (i) => _random.nextInt(256));
  //   return base64Url.encode(values);
  // }

  // String randomChar = CreateCryptoRandomString(5).toUpperCase();

  // print("randomChar------------->: $randomChar");

  // return randomChar;
  // final Uri dynamicUrl = await parameters.buildUrl();
  // print("dynamic url is: $dynamicUrl");
  var _secretCode;
  bool exist = true;
  while (exist) {
    _secretCode = randomAlphaNumeric(6);

    DataSnapshot _data = await FirebaseDatabase.instance
        .reference()
        .child('task/$_secretCode')
        .once();
    if (_data.value == null) {
      exist = false;
    }
  }
  // FirebaseDatabase.instance.reference().task()
  return _secretCode;
}

// final DynamicLinkParameters parameters = DynamicLinkParameters(
//   uriPrefix: 'https://under25competitions.page.link',
//   link: Uri.parse('https://under25competitions.page.link'),
//   androidParameters: AndroidParameters(
//     packageName: 'com.under25.competitions',
//     minimumVersion: 325,
//   ),
//   iosParameters: IosParameters(
//     bundleId: 'com.app.ios',
//     minimumVersion: '3.2.5',
//     appStoreId: '2468101214',
//   ),
//   socialMetaTagParameters: SocialMetaTagParameters(
//     title: 'The title of this dynamic link',
//     description: 'You could add a description too.',
//   ),
// );

String checkPlatform(
  BuildContext context,
) {
  String platform;
  if (TargetPlatform.iOS == Theme.of(context).platform)
    platform = 'IOS';
  else if (TargetPlatform.android == Theme.of(context).platform)
    platform = 'android';
  else
    platform = 'unknown';
  return platform;
}
