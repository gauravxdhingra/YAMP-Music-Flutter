import 'dart:io';

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:test_player/db/database_client.dart';
import 'package:test_player/provider/songs_provider.dart';
import 'package:test_player/screens/now_playing_screen.dart';
import 'package:test_player/support/lastplay.dart';
// import 'package:test_player/widgets/music_tile.dart';

class FavouritesScreen extends StatefulWidget {
  final DatabaseClient db;
  FavouritesScreen(this.db);
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _controller1 = ScrollController();
  List<Song> songs, allSongs;
  bool isLoading = true;

  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  @override
  void initState() {
    super.initState();
    initSongs();
  }

  void initSongs() async {
    allSongs = await widget.db.fetchSongs();
    songs = await widget.db.fetchFavSong();
    print(allSongs.length);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> isFav(song) async {
    if (await widget.db.isfav(song) == 0)
      return true;
    else
      return false;
  }

  // void goToNowPlaying(Song s, {bool nowPlayTap: false}) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => NowPlayingScreen(
  //         song: s,
  //         songData: Provider.of<Songs>(context),
  //         nowPlayTap: nowPlayTap,
  //       ),
  //     ),
  //   );
  // }

  // @override
  // void dispose() {
  //   _controller1.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final songData = Provider.of<Songs>(context);
    // List<Song> _songs = songData.songgsget;
    return Scaffold(
        body: Stack(children: <Widget>[
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Favourites",
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                //   Container(
                //     height: MediaQuery.of(context).size.height / 11,
                //     child: ListView(
                //       scrollDirection: Axis.horizontal,
                //       children: <Widget>[
                //         Container(
                //           margin: EdgeInsets.only(top: 16, left: 0),
                //           width: MediaQuery.of(context).size.width / 1.2,
                //           //  decoration: BoxDecoration(color: Colors.yellow),
                //           child: FadingEdgeScrollView.fromScrollView(
                //             gradientFractionOnStart: 0.05,
                //             gradientFractionOnEnd: 0.03,
                //             child: ListView.builder(
                //               controller: _controller,
                //               physics: BouncingScrollPhysics(),
                //               scrollDirection: Axis.horizontal,
                //               padding: EdgeInsets.zero,
                //               itemCount: _songs.length,
                //               itemBuilder: (BuildContext context, int index) {
                //                 return Container(
                //                   height: 84,
                //                   margin: EdgeInsets.only(bottom: 18),
                //                   child: RecentsTile(
                //                     index: index,
                //                   ),
                //                 );
                //               },
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Divider(
                    thickness: 2,
                    color: Color(0xff7800ee),
                  ),
                ),
                //   SizedBox(
                //     height: 2,
                //   ),
                //   Text(
                //     "My Music",
                //     style: GoogleFonts.montserrat(
                //         color: Colors.white,
                //         fontSize: 20,
                //         fontWeight: FontWeight.w600),
                //   ),
                Container(
                    // margin: EdgeInsets.only( left: 0),
                    height: MediaQuery.of(context).size.height / 1.4,
                    width: MediaQuery.of(context).size.width / 1.15,
                    // decoration: BoxDecoration(color: Colors.yellow),
                    // child: Text('data'),
                    child: isLoading
                        ? Center(
                            child: new CircularProgressIndicator(),
                          )
                        :
                        // songs.length != 0
                        //     ?
                        FadingEdgeScrollView.fromScrollView(
                            gradientFractionOnStart: 0.04,
                            gradientFractionOnEnd: 0.02,
                            child: ListView.builder(
                              controller: _controller1,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: songs.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Column(
                                  children: <Widget>[
                                    new ListTile(
                                      leading: Hero(
                                        tag: allSongs[i].id,
                                        child: songs[i].albumArt != null
                                            ? Image.file(
                                                getImage(songs[i]),
                                                width: 55.0,
                                                height: 55.0,
                                              )
                                            : Icon(Icons.music_note),
                                      ),
                                      title: new Text(allSongs[i].title,
                                          maxLines: 1,
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black)),
                                      subtitle: new Text(
                                        allSongs[i].artist,
                                        maxLines: 1,
                                        style: new TextStyle(
                                            fontSize: 12.0, color: Colors.grey),
                                      ),
                                      trailing: Text(
                                          new Duration(
                                                  milliseconds:
                                                      allSongs[i].duration)
                                              .toString()
                                              .split('.')
                                              .first
                                              .substring(3, 7),
                                          style: new TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.grey)),
                                      onTap: () {
                                        MyQueue.songs = songs;
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new NowPlayingScreen(
                                                        widget.db,
                                                        MyQueue.songs,
                                                        i,
                                                        0)));
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                    // : Center(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Text(
                    //           "Nothing here :(",
                    //           style: TextStyle(
                    //               fontSize: 30.0,
                    //               fontWeight: FontWeight.w600),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
