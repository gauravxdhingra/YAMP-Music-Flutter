import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/loading_spinner.dart';
// import 'package:test_player/screens/now_playing_screen.dart';

import './main_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));
  runApp(LoadingScreen());
}
