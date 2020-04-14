import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import './screens/main_tracks_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/now_playing_screen.dart';
import 'screens/playlist_screen.dart';
import 'screens/search_screen.dart';

Color backgroundColor = Color(0xff7800ee);

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  final List<Song> songs;

  MainPage({this.songs});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static List<Song> _songs;
  @override
  void initState() {
    super.initState();

    _songs = widget.songs;
  }

  List<Widget> _pages = [
    MainTracksScreen(
      _songs,
    ),
    FavouritesScreen(),
    NowPlayingScreen(),
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
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: backgroundColor,
        color: Colors.blue[50],
        // animationDuration: Duration(seconds: 3),
        index: 4,
        items: <Widget>[
          Icon(
            MdiIcons.musicNote,
          ),
          Icon(
            MdiIcons.heart,
          ),
          Icon(
            MdiIcons.playPause,
            // size: 36,
          ),
          Icon(
            MdiIcons.playlistMusic,
          ),
          Icon(
            MdiIcons.magnify,
          ),
        ],
        onTap: (index) {
          _setPage(index);
          // if (index == 2)
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => PlayPage(),),);
        },
        height: 52,
        animationCurve: Curves.fastLinearToSlowEaseIn,
      ),
      body: _pages[_selectedpageindex],
    );
  }
}
