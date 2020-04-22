import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import './musichome.dart';

void main() => runApp(new MyApp());

final _model = ThemeModel();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //         statusBarColor: Colors.transparent));

    return ListenableProvider<ThemeModel>(
      create: (_) => _model..init(),
      child: Consumer<ThemeModel>(
        builder: (context, model, child) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: model.theme,
            home: MusicHome(),
          );
        },
      ),
    );
  }
}
