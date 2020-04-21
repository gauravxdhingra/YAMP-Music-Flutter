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
    }).then((val) {
      scaffoldState.currentState.showSnackBar(new SnackBar(
        content: Text(
          "Songs Updated",
        ),
        duration: Duration(milliseconds: 1500),
      ));
    }).catchError((error) {
      scaffoldState.currentState.showSnackBar(new SnackBar(
        content: Text(
          "Failed to update!",
        ),
        duration: Duration(milliseconds: 1500),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);

    return Scaffold(
      key: scaffoldState,
      backgroundColor: Color(0xff7800ee),
      //  Colors.transparent,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height / 22,
            right: 10,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.142,
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Color(0xff6e00db),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.5,
                    spreadRadius: 0.0,
                    offset: Offset(0.5, 0.5), // shadow direction: bottom right
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Settings'),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('Refresh Database'),
                    subtitle: Text('Your Preferences would be cleared'),
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: new Text(
                                'Do you wish to refresh the database?'),
                            content: new Text(
                                'All your settings and favourites would be cleared!\nThis may take a few seconds.'),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: new Text(
                                  'No',
                                ),
                              ),
                              new FlatButton(
                                color: Colors.red,
                                onPressed: () async {
                                  Navigator.of(context).pop(true);

                                  scaffoldState.currentState
                                      .showSnackBar(new SnackBar(
                                    content: Text(
                                      "Updating Songs",
                                    ),
                                    duration: Duration(milliseconds: 500),
                                  ));

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
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('About'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Text('Change Theme'),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ThemeSet()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share This App'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('About'),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
