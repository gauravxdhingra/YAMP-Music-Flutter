import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_player/database/database_client.dart';
import 'package:test_player/pages/now_playing.dart';
import 'package:test_player/pages/theme_settings.dart';
import 'package:test_player/util/lastplay.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';

class Settings extends StatefulWidget {
  final DatabaseClient db;

  Settings(this.db);

  @override
  State<StatefulWidget> createState() {
    return new SongsState();
  }
}

class SongsState extends State<Settings> {
  String appName;
  String packageName;
  String version;
  String buildNumber;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

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
          child: Row(
            children: <Widget>[
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
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
        Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Refresh Database',
                  ),
                  subtitle: Text(
                    'Your Preferences would be cleared',
                    style: TextStyle(
                        color: _theme.darkMode
                            ? Colors.grey
                            : Colors.white.withOpacity(0.8)),
                  ),
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
              ),
              Container(
                height: 60,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    Icons.color_lens,
                    color: Colors.white,
                  ),
                  title: Text('Change Theme'),
                  subtitle: Text(
                    _theme.darkMode ? 'Pitch Black' : 'Youth',
                    style: TextStyle(
                        color: _theme.darkMode
                            ? Colors.grey
                            : Colors.white.withOpacity(0.8)),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ThemeSet()));
                  },
                ),
              ),
              Container(
                height: 60,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  title: Text('Share This App'),
                  subtitle: Text(
                    'Support us by sharing this app',
                    style: TextStyle(
                        color: _theme.darkMode
                            ? Colors.grey
                            : Colors.white.withOpacity(0.8)),
                  ),
                  onTap: () {
                    Share.share('Hey! Check out this cool music app https://play.google.com/store/apps/details?id=$packageName');
                  },
                ),
              ),
              Container(
                height: 60,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: Text('About'),
                  subtitle: Text(
                    '$version',
                    style: TextStyle(
                        color: _theme.darkMode
                            ? Colors.grey
                            : Colors.white.withOpacity(0.8)),
                  ),
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
              ),
            ],
          ),
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
      ],
    );
  }
}
