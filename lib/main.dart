import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import './musichome.dart';

void main() => runApp(new MyApp());

final _model = ThemeModel(
    // customLightTheme: ThemeData(
    //   scaffoldBackgroundColor: Color(0xff6e00db),
    //   accentColor: Color(0xff7800ee),
    //   backgroundColor: Colors.yellowAccent,
    //   bottomAppBarColor: Colors.yellowAccent,
    //   // Color(0xffFFCE00),
    //   iconTheme: IconThemeData(
    //     color: Colors.black,
    //   ),
    //   cardColor: Colors.white,
    //   textTheme: TextTheme(
    //     headline: TextStyle(
    //       color: Colors.black,
    //     ),
    //     body1: TextStyle(
    //       color: Colors.black,
    //     ),
    //   ),
    // ),
    // customDarkTheme: ThemeData(
    //   scaffoldBackgroundColor: Colors.black.withAlpha(200),
    //   accentColor: Colors.black.withAlpha(200),
    //   //  Colors.black,
    //   backgroundColor: Colors.black.withAlpha(200),
    //   // Colors.grey[900],
    //   // Colors.black38,
    //   cardColor: Colors.black,
    //   bottomAppBarColor: Colors.blueGrey[900],
    //   // Colors.yellowAccent,
    //   // Color(0xffFFCE00),
    //   iconTheme: IconThemeData(
    //     color: Colors.white,
    //   ),
    //   textTheme: TextTheme(
    //     headline: TextStyle(
    //       color: Colors.white,
    //     ),
    //   ),
    //   // accentColor: darkAccentColor ?? null,
    // ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return ListenableProvider<ThemeModel>(
      create: (_) {
        // if (_model.darkMode)
        // _model.changeDarkMode(true);

        return _model..init();
      },
      child: Consumer<ThemeModel>(
        builder: (context, model, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: model.theme,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(milliseconds: 500);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MusicHome(),
      ),
    );
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Container(
        height: 80,
        width: 80,
        child: Image.asset(
          "assets/icon/icon.png",
          fit: BoxFit.cover,
        ),
      )),
    );
  }
}
