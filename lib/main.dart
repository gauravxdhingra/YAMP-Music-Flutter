import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_player/play_page.dart';

import './main_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));
  runApp(MusicPlayerApp());
}
