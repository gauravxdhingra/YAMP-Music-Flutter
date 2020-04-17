import 'dart:math';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_player/db/database_client.dart';

class PlaylistScreen extends StatefulWidget {
  final DatabaseClient db;
  PlaylistScreen(this.db);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {

 var mode;
  List<Song> songs;
  var selected;
  String atFirst,atSecond,atThir;
  String nu = "null";
  Orientation orientation;
  @override
  void initState() {
    super.initState();
    _lengthFind();
    setState(() {
    });
    mode = 1;
    selected = 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _lengthFind() async {
    var random = Random();
    songs = await widget.db.fetchRecentSong();
    setState(() {
      atFirst = songs[random.nextInt(songs.length-1)].artist;
    });
    songs = await widget.db.fetchTopSong();
    setState(() {
      atSecond = songs[random.nextInt(songs.length-1)].artist;
    });
    songs = await widget.db.fetchFavSong();
    String atThird = "No Songs in favorites";
    setState(() {
      atThir = songs.length != 0
          ? "Includes ${songs[random.nextInt(songs.length-1)].artist.toString()} and more"
          : atThird;
    });

  }


  @override
  Widget build(BuildContext context) {
    return
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Icon(
                  //   Icons.favorite,
                  //   color: Colors.white,
                  // ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  Text(
                    "Playlists",
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
                // child: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
