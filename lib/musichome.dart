import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/now_playing.dart';
// import 'package:musicplayer/util/AAppBar.dart';
// import 'package:musicplayer/util/lastplay.dart';
// import 'package:musicplayer/views/album.dart';
// import 'package:musicplayer/views/artists.dart';
// import 'package:musicplayer/views/home.dart';
// import 'package:musicplayer/views/playlists.dart';
// import 'package:musicplayer/views/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_player/pages/now_playing.dart';
// import 'package:test_player/util/AAppBar.dart';
import 'package:test_player/util/lastplay.dart';
import 'package:test_player/views/album.dart';
import 'package:test_player/views/artists.dart';
import 'package:test_player/views/home.dart';
import 'package:test_player/views/playlists.dart';
import 'package:test_player/views/songs.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import './views/setings.dart';

import 'database/database_client.dart';

class BodySelection extends StatelessWidget {
  BodySelection(this._selectedIndex, this.db);

  final DatabaseClient db;
  final int _selectedIndex;

  selectionPage(int pos) {
    switch (pos) {
      case 0:
        return Songs(db);
      case 1:
        return Songs(db);
      case 4:
        return Settings(db);
      case 3:
        // search
        return Album(db);
      case 2:
        // fav
        return Playlist(db);
      default:
        return Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    // return selectionPage(_selectedIndex);
    return Scaffold(
      backgroundColor:
          // Colors.black.withAlpha(200),
          Theme.of(context).scaffoldBackgroundColor,
      // _theme.backgroundColor,
      // Color(0xff7800ee),
      // Colors.black,
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
                color: Theme.of(context).accentColor,
                // _theme.accentColor,
                // Color(0xff6e00db),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _theme.darkMode
                        ? Theme.of(context)
                            .textTheme
                            .headline
                            .color
                            .withOpacity(0.0)
                        : Theme.of(context)
                            .textTheme
                            .headline
                            .color
                            .withOpacity(0.20),
                    // Colors.white,
                    // black26,
                    blurRadius: 0.5,
                    spreadRadius: 0.0,
                    offset: Offset(0.5, 0.5), // shadow direction: bottom right
                  )
                ],
              ),
              child: selectionPage(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}

class MusicHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MusicState();
  }
}

class _MusicState extends State<MusicHome> {
  int _selectedIndex = 1;
  int serIndex;
  List<Song> songs;
  List<String> title = ["", "Albums", "Songs", "Artists", "Playlists"];
  DatabaseClient db;
  bool isLoading = true;
  Song last;
  List<BottomItem> bottomItems;
  List<dynamic> bottomOptions;

  _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
  }

  bool _handlingIsSelected(int pos) {
    return _selectedIndex == pos;
  }

  initBottomItems() {
    bottomItems = [
      // new BottomItem("Home", Icons.home, null, null),
      new BottomItem(
        "Songs",
        Icons.music_note,
        () async {
          _onSelectItem(1);
        },
        _handlingIsSelected(1),
      ),
      new BottomItem("Playlists", Icons.favorite, () async {
        _onSelectItem(2);
      }, _handlingIsSelected(2)),
      new BottomItem("Albums", Icons.album, () async {
        _onSelectItem(4);
      }, _handlingIsSelected(4)),
      new BottomItem("Search", Icons.person, () async {
        _onSelectItem(3);
      }, _handlingIsSelected(3)),
    ];
    bottomOptions = <Widget>[];
    for (var i = 1; i < bottomItems.length; i++) {
      var d = bottomItems[i];
      // if (i == 2 || i == 4) {
      //   bottomOptions.add(Padding(
      //       padding: EdgeInsets.symmetric(
      //           horizontal: MediaQuery.of(context).size.width * 0.03)));
      // }
      // if (i == 3) {
      //   bottomOptions.add(Padding(
      //       padding: EdgeInsets.symmetric(
      //           horizontal: MediaQuery.of(context).size.width * 0.15)));
      // }
      bottomOptions.add(new IconButton(
        icon: Icon(d.icon,
            color: d.isSelected ? Color(0xff373a46) : Colors.blueGrey.shade600),
        onPressed: d.onPressed,
        tooltip: d.tooltip,
        iconSize: 32.0,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() async {
    db = new DatabaseClient();
    await db.create();
    if (await db.alreadyLoaded()) {
      setState(() {
        isLoading = false;
        getLast();
      });
    } else {
      var songs;
      try {
        songs = await MusicFinder.allSongs();
      } catch (e) {
        print("failed to get songs");
      }
      List<Song> list = new List.from(songs);
      for (Song song in list) db.insertOrUpdateSong(song);
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        getLast();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLast() async {
    last = await db.fetchLastSong();
    songs = await db.fetchSongs();
    setState(() {
      songs = songs;
    });
  }

  int indexx = 0;

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

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    initBottomItems();
    return new WillPopScope(
      child: new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        // Color(0xff7800ee),
        key: scaffoldState,
        // appBar: _selectedIndex == 0
        //     ? null
        //     : GreyAppBar(
        //         title: title[_selectedIndex].toLowerCase(),
        //       ),
        floatingActionButton: new FloatingActionButton.extended(
            label: Text(
              'Now Playing',
              style: Theme.of(context).textTheme.headline,
            ),
            icon: Icon(MdiIcons.play,
                color: Theme.of(context).textTheme.headline.color),
            backgroundColor: Theme.of(context).bottomAppBarColor,
            // Colors.yellowAccent,
            onPressed: () async {
              var pref = await SharedPreferences.getInstance();
              var fp = pref.getBool("played");
              if (fp == null) {
                scaffoldState.currentState.showSnackBar(new SnackBar(
                  content: Text("Play your first song."),
                  duration: Duration(milliseconds: 1500),
                ));
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  if (MyQueue.songs == null) {
                    List<Song> list = new List();
                    list.add(last);
                    MyQueue.songs = list;
                    return new NowPlaying(db, list, 0, 0);
                  } else
                    return new NowPlaying(db, MyQueue.songs, MyQueue.index, 1);
                }));
              }
            }),

        // floatingActionButton: new FloatingActionButton(
        //     child: Icon(MdiIcons.play, color: Colors.black),
        //     backgroundColor: Colors.yellowAccent,
        //     onPressed: () async {
        //       var pref = await SharedPreferences.getInstance();
        //       var fp = pref.getBool("played");
        //       if (fp == null) {
        //         scaffoldState.currentState.showSnackBar(
        //             new SnackBar(content: Text("Play your first song.")));
        //       } else {
        //         Navigator.of(context)
        //             .push(new MaterialPageRoute(builder: (context) {
        //           if (MyQueue.songs == null) {
        //             List<Song> list = new List();
        //             list.add(last);
        //             MyQueue.songs = list;
        //             return new NowPlaying(db, list, 0, 0);
        //           } else
        //             return new NowPlaying(db, MyQueue.songs, MyQueue.index, 1);
        //         }));
        //       }
        //     }),
        body: isLoading
            ? Container(
                // height: 400, width: 400,
                child: Center(
                    child: SpinKitThreeBounce(
                  color: Colors.blueGrey,
                  size: 100,
                )
                    // CircularProgressIndicator()
                    ),
              )
            : BodySelection(_selectedIndex, db),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor:
              // Colors.black.withAlpha(200),
              Theme.of(context).scaffoldBackgroundColor,
          // Color(0xff7800ee),
          color: Theme.of(context).bottomAppBarColor,
          // Colors.yellowAccent,
          height: 52,
          index: _selectedIndex - 1,
          items: <Widget>[
            Icon(Icons.music_note),
            Icon(Icons.favorite),
            // Icon(Icons.album),
            Icon(Icons.search),
            Icon(Icons.settings),
          ],
          onTap: (i) async {
            _onSelectItem(i + 1);
            BodySelection(i, db).selectionPage(i);
            _handlingIsSelected(i + 1);
          },
        ),
        // BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   child: Container(
        //     color: Colors.transparent,
        //     height: 55.0,
        //     child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: bottomOptions),
        //   ),
        //   notchMargin: 10.0,
        //   elevation: 0.0,
        //   color: Colors.grey.withOpacity(0.25),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    if (_selectedIndex != 1) {
      setState(() {
        _selectedIndex = 1;
      });
      return null;
    } else
      return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: new Text(
                  'Are you sure?',
                  style: Theme.of(context).textTheme.headline,
                ),
                content: new Text(
                  'Do you wish to quit YAMP',
                  style: Theme.of(context).textTheme.headline,
                ),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(
                      'No',
                      // style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                  new FlatButton(
                    onPressed: () {
                      MyQueue.player.stop();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(
                      'Yes',
                      // style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ],
              );
            },
          ) ??
          false;
  }
}

class BottomItem {
  String tooltip;
  IconData icon;
  VoidCallback onPressed;
  bool isSelected;

  BottomItem(
      [this.tooltip, this.icon, this.onPressed, this.isSelected = false]);
}
