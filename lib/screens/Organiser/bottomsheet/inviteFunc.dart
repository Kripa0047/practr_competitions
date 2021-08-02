import 'dart:typed_data';
import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:practrCompetitions/common/common.dart';

Future<void> captureAndSharePng(
  GlobalKey globalKey,
  String url,
) async {
  try {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    shareQrCode(pngBytes, url);
  } catch (e) {
    print(e.toString());
  }
}

shareQrCode(List<int> bytes, String url) async {
  await Share.file(
    'QrCode',
    'QrCode.png',
    bytes,
    'image/png',
    text:
        'Hey! You were just invited to register for $orgCompetetionName. Scan that QR code or simply click this link - $url',
  );
}
