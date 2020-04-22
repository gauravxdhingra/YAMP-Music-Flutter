import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_player/database/database_client.dart';
import 'package:test_player/pages/now_playing.dart';
import 'package:test_player/pages/theme_settings.dart';
import 'package:test_player/util/lastplay.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final DatabaseClient db;

  Settings(this.db);

  @override
  State<StatefulWidget> createState() {
    return new SongsState();
  }
}

class SongsState extends State<Settings> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  Future<Null> refreshData() async {
    var db = new DatabaseClient();
    await MusicFinder.allSongs().then((songs) {
      List<Song> newSongs = List.from(songs);
      for (Song song in newSongs) db.insertOrUpdateSong(song);
    });
    // .then((val) {
    //   scaffoldState.currentState.showSnackBar(new SnackBar(
    //     content: Text(
    //       "Songs Updated",
    //     ),
    //     duration: Duration(milliseconds: 1500),
    //   ));
    // }).catchError((error) {
    //   scaffoldState.currentState.showSnackBar(new SnackBar(
    //     content: Text(
    //       "Failed to update!",
    //     ),
    //     duration: Duration(milliseconds: 1500),
    //   ));
    // });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: _theme.darkMode
                ? Theme.of(context).textTheme.headline.color
                : Color(0xff6e00db),
            // Color(0xff7800ee),
            thickness: _theme.darkMode ? 0.5 : 2.5,
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          title: Text(
            'Refresh Database',
          ),
          subtitle: Text('Your Preferences would be cleared'),
          onTap: () {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: new Text(
                    'Do you wish to refresh the database?',
                    style: Theme.of(context).textTheme.headline,
                  ),
                  content: new Text(
                    'All your settings and favourites would be cleared!\nThis may take a few seconds.',
                    style: Theme.of(context).textTheme.headline,
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: new Text(
                        'No',
                      ),
                    ),
                    new FlatButton(
                      color: Colors.red,
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                        await refreshData();
                      },
                      child: new Text(
                        'Proceed',
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        // ListTile(
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        //   leading: Icon(
        //     Icons.info_outline,
        //     color: Colors.white,
        //   ),
        //   title: Text('About'),
        //   onTap: () {},
        // ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(
            Icons.color_lens,
            color: Colors.white,
          ),
          title: Text('Change Theme'),
          subtitle: Text('Youth / Black'),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ThemeSet()));
          },
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(
            Icons.share,
            color: Colors.white,
          ),
          title: Text('Share This App'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          title: Text('About'),
          subtitle: Text('v1.0.0'),
          onTap: () {
            return showAboutDialog(
                context: context,
                applicationName: 'Yamp',
                applicationLegalese: 'MIT',
                children: <Widget>[
                  // Text('GGG')
                ]);
          },
        ),
      ],
    );
  }
}
