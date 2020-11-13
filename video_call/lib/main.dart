import 'package:flutter/material.dart';
import 'package:video_call/const/booleans.dart';
import 'package:video_call/const/strings.dart';
import 'package:video_call/pages/mainpage.dart';

void main() {
  String serverAddress = '159.65.140.106';

  runApp(VideoCaller(
    appname: Strings.appname,
    serverIp: '$serverAddress',
    isDebugTagVisible: Booleans.isDebugTagShow,
  ));
}
