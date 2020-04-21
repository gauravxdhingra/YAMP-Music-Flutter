import 'package:flutter/material.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:persist_theme/ui/switches/dark_mode.dart';
import 'package:persist_theme/ui/switches/true_black.dart';
import 'package:provider/provider.dart';

class ThemeSet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persist Theme'),
      ),
      body: ListView(
        children: MediaQuery.of(context).size.width >= 40
            ? <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(child: DarkModeSwitch()),
                    Flexible(child: TrueBlackSwitch()),
                  ],
                ),
                CustomThemeSwitch(),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(child: PrimaryColorPicker()),
                    Flexible(child: AccentColorPicker()),
                  ],
                ),
                DarkAccentColorPicker(),
              ]
            : <Widget>[
                DarkModeSwitch(),
                TrueBlackSwitch(),
                CustomThemeSwitch(),
                PrimaryColorPicker(),
                AccentColorPicker(),
                DarkAccentColorPicker(),
              ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _theme.accentColor,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
