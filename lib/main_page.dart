import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
import './provider/songs_provider.dart';

Color backgroundColor = Color(0xff7800ee);

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Songs(null),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (ctx) => LoadingScreen(),
          MainPage.routeName: (ctx) => MainPage(),
        },
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
  @override
  void initState() {
    super.initState();
    // _songs = widget.songs;
    // widget.songs.forEach((ele) => _songs.add(ele));
    // print(_songs.length);
    // print(_songs[25].title);
    _setPage(0);
  }

  // List get songs => _songs;
  // static BuildContext ctx;
  List<Widget> pages = [
    MainTracksScreen(),
    FavouritesScreen(),
    // NowPlayingScreen(
    //     // song: Provider.of<Songs>(ctx)
    //     //     .songgsget[Provider.of<Songs>(ctx).currentIndex],
    //     // songData: Provider.of<Songs>(ctx),
    //     // nowPlayTap: true,
    //     ),
    PlaylistScreen(),
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 48,
            top: 0,
            right: 0,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.play_circle_outline,
                        size: 40,
                      ),
                      FlatButton(
                          child: Text(
                            'Now Playing',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                            // textAlign: TextAlign.center,
                          ),
                          onPressed: () => {}
                          //  showSearch(// context: context, delegate: CustomSearchDelegate()),
                          ),
                    ],
                  ),
                ],
              ),

              // showSearch(context: context, delegate: CustomSearchDelegate()),
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
          // if (i == 2)
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (_) => NowPlayingScreen(
          //         song: songData.songgsget[songData.currentIndex],
          //         songData: Provider.of<Songs>(context),
          //         nowPlayTap: false,
          //       ),
          //     ),
          //   );
          // else
          _setPage(i);
        },
        height: 52,
        // animationCurve: Curves.fastLinearToSlowEaseIn,
      ),
    );
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
