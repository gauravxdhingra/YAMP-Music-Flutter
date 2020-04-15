import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_player/provider/songs_provider.dart';
import 'package:test_player/screens/now_playing_screen.dart';
import '../widgets/music_tile.dart';
import '../widgets/recents_tile.dart';

class MainTracksScreen extends StatefulWidget {
  @override
  _MainTracksScreenState createState() => _MainTracksScreenState();
}

class _MainTracksScreenState extends State<MainTracksScreen> {
  final _controller = ScrollController();
  final _controller1 = ScrollController();
// List<Song> tracks = widget.songs;
  // static List<Song> _songs;

  // @override
  // void initState() {
  //   super.initState();
  //   _songs = widget.songs;
  //   print(_songs.length);
  // }

  void goToNowPlaying(Song s, {bool nowPlayTap: false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlayingScreen(
          song: s,
          songData: Provider.of<Songs>(context),
          nowPlayTap: nowPlayTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final songsData = Provider.of<Songs>(context);
    List<Song> _songs = songsData.songgsget;
    return Stack(
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
          ),
        ),
//          6e00db
        Positioned(
          // bottom: 0,
          top: MediaQuery.of(context).size.height / 7.85,
          right: 15,
          left: 0,
          child: Container(
            height: MediaQuery.of(context).size.height / 1.27,
            padding: EdgeInsets.only(left: 24, top: 24),
            decoration: BoxDecoration(
              color: Color(0xff6e00db),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(42),
                bottomRight: Radius.circular(42),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Recent Songs",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 11,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 16, left: 0),
                          width: MediaQuery.of(context).size.width / 1.2,
                          //  decoration: BoxDecoration(color: Colors.yellow),
                          child: FadingEdgeScrollView.fromScrollView(
                            gradientFractionOnStart: 0.05,
                            gradientFractionOnEnd: 0.03,
                            child: ListView.builder(
                              controller: _controller,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemCount: _songs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 84,
                                  margin: EdgeInsets.only(bottom: 18),
                                  child: RecentsTile(
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Divider(
                      thickness: 2,
                      color: Color(0xff7800ee),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "My Music",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 0),
                    height: MediaQuery.of(context).size.height / 1.7415,
                    width: MediaQuery.of(context).size.width / 1.15,
                    // decoration: BoxDecoration(color: Colors.yellow),
                    // child: Text('data'),
                    child: FadingEdgeScrollView.fromScrollView(
                      gradientFractionOnStart: 0.04,
                      gradientFractionOnEnd: 0.02,
                      child: ListView.builder(
                        controller: _controller1,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _songs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 11),
                            width: MediaQuery.of(context).size.width / 1.3,
                            decoration: BoxDecoration(
                                // color: Colors.purple,
                                ),
                            child: GestureDetector(
                              onTap: () => goToNowPlaying(
                                _songs[index],
                              ),
                              // {songsData.playLocal(_songs[index].uri)},
                              child: MusicTile(
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
