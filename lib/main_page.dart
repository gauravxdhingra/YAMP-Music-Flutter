import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:test_player/screens/favourites_screen.dart';
import 'package:test_player/screens/loading_spinner.dart';
import 'package:test_player/screens/main_tracks_screen.dart';
import 'package:test_player/screens/now_playing_screen.dart';
import 'package:test_player/screens/playlist_screen.dart';
import 'package:test_player/screens/search_screen.dart';

// import './screens/loading_spinner.dart';
// import './widgets/music_tile.dart';
// import './widgets/recents_tile.dart';
import 'package:provider/provider.dart';
import 'package:test_player/support/lastplay.dart';
import './provider/songs_provider.dart';
import 'db/database_client.dart';

Color backgroundColor = Color(0xff7800ee);

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Songs(null),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        // routes: {
        //   '/': (ctx) => LoadingScreen(),
        //   MainPage.routeName: (ctx) => MainPage(),
        // },
      ),
    );
  }
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
  static DatabaseClient db;
  bool isLoading = true;
  Song last;
  List<Song> songs;

  @override
  void initState() {
    super.initState();
    // _songs = widget.songs;
    // widget.songs.forEach((ele) => _songs.add(ele));
    // print(_songs.length);
    // print(_songs[25].title);
    initPlayer();
    _setPage(0);
  }

  void initPlayer() async {
    DatabaseClient db;
    int _selectedIndex;
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

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  // List get songs => _songs;
  // static BuildContext ctx;
  List<Widget> pages = [
    MainTracksScreen(db: db),
    FavouritesScreen(db),
    // NowPlayingScreen(
    //     // song: Provider.of<Songs>(ctx)
    //     //     .songgsget[Provider.of<Songs>(ctx).currentIndex],
    //     // songData: Provider.of<Songs>(ctx),
    //     // nowPlayTap: true,
    //     ),
    PlaylistScreen(db),
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

  @override
  Widget build(BuildContext context) {
    final songData = Provider.of<Songs>(context);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 48,
              top: 0,
              right: 0,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(42),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height / 9.5,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(42),
                    ),
                  ),

                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.play_circle_outline,
                            size: 40,
                          ),

                          Text(
                            'Now Playing',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                            // textAlign: TextAlign.center,
                          ),

                          //  showSearch(// context: context, delegate: CustomSearchDelegate()),
                        ],
                      ),
                    ],
                  ),
                  // showSearch(context: context, delegate: CustomSearchDelegate()),
                ),
                onTap: () {},
              ),
            ),
            pages[_selectedpageindex],
          ],
        ),

        // MainTracksScreen(),

        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: backgroundColor,
          color: Colors.yellow,
          // Colors.blue[50],
          // animationDuration: Duration(seconds: 3),
          // index: 3,
          index: 0,
          items: <Widget>[
            Icon(
              MdiIcons.musicNote,
            ),
            Icon(
              MdiIcons.heart,
            ),
            // Icon(
            //   MdiIcons.playPause,
            //   // size: 36,
            // ),
            Icon(
              MdiIcons.playlistMusic,
            ),
            Icon(
              MdiIcons.magnify,
            ),
          ],
          onTap: (i) {
            _setPage(i);
          },
          height: 52,
          // animationCurve: Curves.fastLinearToSlowEaseIn,
        ),
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
                content: new Text('Grey will be stopped..'),
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
