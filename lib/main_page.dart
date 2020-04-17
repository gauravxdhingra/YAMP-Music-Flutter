import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:test_player/screens/favourites_screen.dart';
import 'package:test_player/screens/main_tracks_screen.dart';
import 'package:test_player/screens/now_playing_screen.dart';
import 'package:test_player/screens/playlist_screen.dart';
import 'package:test_player/screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import './screens/loading_spinner.dart';
// import './widgets/music_tile.dart';
// import './widgets/recents_tile.dart';
import 'package:provider/provider.dart';
import 'package:test_player/support/lastplay.dart';
import './provider/songs_provider.dart';
import 'db/database_client.dart';

Color backgroundColor = Color(0xff7800ee);

class PageSelector extends StatelessWidget {
  PageSelector(this.db, this._selectedIndex);
  final DatabaseClient db;
  final int _selectedIndex;

  _selectionPage(int pos) {
    switch (pos) {
      case 0:
        return MainTracksScreen(db);
      case 2:
        return MainTracksScreen(db);
      case 3:
        return SearchScreen();
      case 1:
        return FavouritesScreen(db);
      case 4:
        return PlaylistScreen(db);
      default:
        return Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _selectionPage(_selectedIndex);
  }
}

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    // create: (ctx) => Songs(),
    // child:
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      // routes: {
      //   '/': (ctx) => LoadingScreen(),
      //   MainPage.routeName: (ctx) => MainPage(),
      // },
      // ),
    );
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

class MainPage extends StatefulWidget {
  static const routeName = '/main-page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final _controller = ScrollController();
  // final _controller1 = ScrollController();
  // static List<Song> _songs = [];
  DatabaseClient db;
  bool isLoading = true;
  Song last;
  List<Song> songs;
  List<BottomItem> bottomItems;
  List<dynamic> bottomOptions;
  int _selectedIndex = 0;
  int serIndex;

  static DatabaseClient dbst = new DatabaseClient();

  _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
  }

  bool _handlingIsSelected(int pos) {
    return _selectedIndex == pos;
  }

  initBottomItems() {
    bottomItems = [
      new BottomItem("Home", Icons.home, null, null),
      new BottomItem("Albums", Icons.album, () async {
        _onSelectItem(1);
      }, _handlingIsSelected(1)),
      new BottomItem("Songs", Icons.music_note, () async {
        _onSelectItem(2);
      }, _handlingIsSelected(2)),
      new BottomItem("Artists", Icons.person, () async {
        _onSelectItem(3);
      }, _handlingIsSelected(3)),
      new BottomItem("Playlists", Icons.playlist_play, () async {
        _onSelectItem(4);
      }, _handlingIsSelected(4)),
    ];
    bottomOptions = <Widget>[];
    for (var i = 1; i < bottomItems.length; i++) {
      var d = bottomItems[i];
      if (i == 2 || i == 4) {
        bottomOptions.add(Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03)));
      }
      if (i == 3) {
        bottomOptions.add(Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15)));
      }
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
    // initBottomItems();
    // _songs = widget.songs;
    // widget.songs.forEach((ele) => _songs.add(ele));
    // print(_songs.length);
    // print(_songs[25].title);
    initPlayer();
    _setPage(0);
  }

  void initPlayer() async {
    db = new DatabaseClient();
    await db.create();
    if (await db.alreadyLoaded()) {
      setState(() {
        isLoading = false;
        // getLast();
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
        // getLast();
      });
    }
    dbst = db;
  }

  void getLast() async {
    last = await db.fetchLastSong();
    songs = await db.fetchSongs();
    setState(() {
      songs = songs;
    });
  }

  Future<Null> refreshData() async {
    var db = new DatabaseClient();
    await MusicFinder.allSongs().then((songs) {
      List<Song> newSongs = List.from(songs);
      for (Song song in newSongs) db.insertOrUpdateSong(song);
    }).then((val) {
      scaffoldState.currentState.showSnackBar(new SnackBar(
        content: Text(
          "Database Updated",
        ),
        duration: Duration(milliseconds: 1500),
      ));
    }).catchError((error) {
      scaffoldState.currentState.showSnackBar(new SnackBar(
        content: Text(
          "Failed to update database",
        ),
        duration: Duration(milliseconds: 1500),
      ));
    });
  }

  // List get songs => _songs;
  // static BuildContext ctx;
  List<Widget> pages = [
    MainTracksScreen(dbst),
    FavouritesScreen(dbst),
    PlaylistScreen(dbst),
    SearchScreen(),
  ];

  // Future _playLocal(String url) async {
  //   final result = await audioPlayer.play(url, isLocal: true);
  // }

  int _selectedpageindex = 0;

  void _setPage(int index) {
    setState(() {
      _selectedpageindex = index;
    });
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    // final songData = Provider.of<Songs>(context);
    initBottomItems();
    return WillPopScope(
      child: Scaffold(
        key: scaffoldState,
        backgroundColor: backgroundColor,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _selectedIndex == 0
                ? RefreshIndicator(
                    child: PageSelector(
                      db,
                      _selectedIndex,
                    ),
                    color: Colors.blueGrey,
                    onRefresh: refreshData,
                    backgroundColor: Colors.white,
                  )
                : PageSelector(
                    db,
                    _selectedIndex,
                  ),
        // isLoading
        //     ? CircularProgressIndicator()
        //     : Stack(
        //         children: <Widget>[
        //           Positioned(
        //             left: 48,
        //             top: 0,
        //             right: 0,
        //             child: InkWell(
        //                 // borderRadius: BorderRadius.only(
        //                 //   bottomLeft: Radius.circular(42),
        //                 // ),

        //                 child: Container(
        //                   height: MediaQuery.of(context).size.height / 9.5,
        //                   decoration: BoxDecoration(
        //                     color: Colors.yellow,
        //                     borderRadius: BorderRadius.only(
        //                       bottomLeft: Radius.circular(42),
        //                     ),
        //                   ),

        //                   child: Column(
        //                     children: <Widget>[
        //                       SizedBox(
        //                         height: 35,
        //                       ),
        //                       Row(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         // crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: <Widget>[
        //                           Icon(
        //                             Icons.play_circle_outline,
        //                             size: 40,
        //                           ),

        //                           Text(
        //                             'Now Playing',
        //                             style: GoogleFonts.montserrat(
        //                               color: Colors.black,
        //                               fontSize: 30,
        //                               fontWeight: FontWeight.w500,
        //                             ),
        //                             // textAlign: TextAlign.center,
        //                           ),

        //                           //  showSearch(// context: context, delegate: CustomSearchDelegate()),
        //                         ],
        //                       ),
        //                     ],
        //                   ),
        //                   // showSearch(context: context, delegate: CustomSearchDelegate()),
        //                 ),
        //                 onTap: () async {
        //                   var pref = await SharedPreferences.getInstance();
        //                   var fp = pref.getBool("played");
        //                   if (fp == null) {
        //                     scaffoldState.currentState.showSnackBar(
        //                         new SnackBar(
        //                             content: Text("Play your first song.")));
        //                   } else {
        //                     Navigator.of(context)
        //                         .push(new MaterialPageRoute(builder: (context) {
        //                       if (MyQueue.songs == null) {
        //                         List<Song> list = new List();
        //                         list.add(last);
        //                         MyQueue.songs = list;
        //                         return new NowPlayingScreen(db, list, 0, 0);
        //                       } else
        //                         return new NowPlayingScreen(
        //                             db, MyQueue.songs, MyQueue.index, 1);
        //                     }));
        //                   }
        //                 }),
        //           ),
        //           pages[_selectedpageindex],
        //         ],
        //       ),

        // MainTracksScreen(),

        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            color: Colors.transparent,
            height: 55.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bottomOptions),
          ),
          notchMargin: 10.0,
          elevation: 0.0,
          color: Colors.grey.withOpacity(0.25),
        ),
        // CurvedNavigationBar(
        //   backgroundColor: backgroundColor,
        //   color: Colors.yellow,
        //   // Colors.blue[50],
        //   // animationDuration: Duration(seconds: 3),
        //   // index: 3,
        //   index: 0,
        //   items: <Widget>[
        //     Icon(
        //       MdiIcons.musicNote,
        //     ),
        //     Icon(
        //       MdiIcons.heart,
        //     ),
        //     // Icon(
        //     //   MdiIcons.playPause,
        //     //   // size: 36,
        //     // ),
        //     Icon(
        //       MdiIcons.playlistMusic,
        //     ),
        //     Icon(
        //       MdiIcons.magnify,
        //     ),
        //   ],
        //   onTap: (i) {
        //     _setPage(i);
        //   },
        //   height: 52,
        //   // animationCurve: Curves.fastLinearToSlowEaseIn,
        // ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    if (_selectedpageindex != 0) {
      setState(() {
        _selectedpageindex = 0;
      });
      return null;
    } else
      return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Exit?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(
                      'No',
                    ),
                  ),
                  new FlatButton(
                    onPressed: () {
                      MyQueue.player.stop();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes'),
                  ),
                ],
              );
            },
          ) ??
          false;
  }
}

// class SongsSearch extends SearchDelegate<String> {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     // TODO: implement buildActions
//     final songs = Provider.of<Songs>(context).songgsget;
//     return null;
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     // TODO: implement buildLeading
//     return null;
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     return null;
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     return null;
//   }
// }
