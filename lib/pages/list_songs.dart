import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/now_playing.dart';
// import 'package:musicplayer/util/AAppBar.dart';
// import 'package:musicplayer/util/lastplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
import 'package:test_player/database/database_client.dart';
import 'package:test_player/pages/now_playing.dart';
// import 'package:test_player/util/AAppBar.dart';
import 'package:test_player/util/lastplay.dart';

class ListSongs extends StatefulWidget {
  final DatabaseClient db;
  final int mode;
  final Orientation orientation;

  // mode =1=>recent, 2=>top, 3=>fav
  ListSongs(this.db, this.mode, this.orientation);

  @override
  State<StatefulWidget> createState() {
    return new _ListSong();
  }
}

class _ListSong extends State<ListSongs> {
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

  // void _modelBottomSheet() {
  //   List<bool> isFavorite = new List(allSongs.length);
  //   for (int m = 0; m < allSongs.length; m++) isFavorite[m] = false;
  //   bool isFavoriteX;
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (builder) {
  //       return Container(
  //         decoration: ShapeDecoration(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(6.0),
  //                     topRight: Radius.circular(6.0))),
  //             color: Color(0xFFFAFAFA)),
  //         child: Scrollbar(
  //           child: ListView.builder(
  //             padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
  //             itemCount: allSongs.length,
  //             physics: BouncingScrollPhysics(),
  //             itemBuilder: (context, i) {
  //               isFavoriteX = true;
  //               return ListTile(
  //                 title: Text(allSongs[i].title,
  //                     maxLines: 1,
  //                     style: new TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 16.0,
  //                     )),
  //                 leading: allSongs[i].albumArt != null
  //                     ? Image.file(
  //                         getImage(allSongs[i]),
  //                         width: 55.0,
  //                         height: 55.0,
  //                       )
  //                     : Icon(Icons.music_note),
  //                 subtitle: new Text(
  //                   allSongs[i].artist,
  //                   maxLines: 1,
  //                   style: new TextStyle(fontSize: 12.0, color: Colors.grey),
  //                 ),
  //                 trailing: RawMaterialButton(
  //                     shape: CircleBorder(),
  //                     child: !isFavorite[i] || isFavoriteX
  //                         ? Icon(Icons.add)
  //                         : Icon(Icons.remove),
  //                     fillColor: Color(0xFFefece8),
  //                     onPressed: () async {
  //                       setState(() {
  //                         isFavorite[i] = true;
  //                         isFavoriteX = false;
  //                       });
  //                       await widget.db.favSong(allSongs[i]);
  //                     }),
  //                 onTap: () {
  //                   MyQueue.songs = allSongs;
  //                   Navigator.of(context).push(
  //                     new MaterialPageRoute(
  //                       builder: (context) =>
  //                           new NowPlaying(widget.db, MyQueue.songs, i, 0),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    // initSongs();
    // songs.sort((so));
    final _controller1 = ScrollController();
    return isLoading
            ? new Center(
                child: SpinKitThreeBounce(
                  color: _theme.darkMode
                      ? Colors.blueGrey
                      : Theme.of(context).bottomAppBarColor,
                  size: 30,
                ),
                // child: new CircularProgressIndicator(),
              )
            : Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          size: 30,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Favourites',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                          // TextStyle(
                          //   color: Colors.white,
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 25,
                          // ),
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
                  songs.length != 0
                      ? DraggableScrollbar.rrect(
                          labelTextBuilder: (double offset) =>
                              Text("${offset ~/ 100}"),
                          // alwaysVisibleScrollThumb: true,
                          scrollbarTimeToFade: Duration(milliseconds: 300),
                          controller: _controller1,
                          // heightScrollThumb: 40,
                          heightScrollThumb: 55,
                          backgroundColor: Theme.of(context).backgroundColor,
                          // backgroundColor: Theme.of(context).accentColor,
                          // Theme.of(context).scaffoldBackgroundColor,
                          // Color(0xffFFCE00),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: FadingEdgeScrollView.fromScrollView(
                              gradientFractionOnStart: 0.04,
                              gradientFractionOnEnd: 0.05,
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                controller: _controller1,
                                physics: BouncingScrollPhysics(),
                                itemCount: songs.length,
                                itemBuilder: (context, i) => Column(
                                  children: <Widget>[
                                    Hero(
                                      tag: songs[i].id,
                                      child: Container(
                                        height: 70,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 0,
                                            bottom: 0,
                                          ),
                                          leading: songs[i].albumArt != null
                                              // tag: songs[i].id,
                                              ? CircleAvatar(
                                                  backgroundImage: FileImage(
                                                    getImage(songs[i]),
                                                    // width: 55.0,
                                                    // height: 55.0,
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: _theme
                                                          .darkMode
                                                      ? Theme.of(context)
                                                          .bottomAppBarColor
                                                      : Theme.of(context)
                                                          .scaffoldBackgroundColor,
                                                  child: Center(
                                                    child: Text(songs[i]
                                                        .title[0]
                                                        .toUpperCase()),
                                                  ),
                                                ),
                                          title: new Text(
                                            songs[i].title,
                                            maxLines: 1,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              // fontWeight: FontWeight.w500
                                            ),
                                          ),

                                          //  TextStyle(
                                          //     fontSize: 16.0,
                                          //     color: Colors.white,
                                          //     fontWeight: FontWeight.w500)),
                                          subtitle: new Text(songs[i].artist,
                                              maxLines: 1,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 12.0,
                                                  color: Colors.white)

                                              // TextStyle(
                                              //     fontSize: 12.0,
                                              //     color: Colors.white),
                                              ),
                                          trailing: widget.mode == 2
                                              ? new Text(
                                                  (i + 1).toString(),
                                                  style: new TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.white),
                                                )
                                              : new Text(
                                                  new Duration(
                                                          milliseconds:
                                                              songs[i].duration)
                                                      .toString()
                                                      .split('.')
                                                      .first
                                                      .substring(3, 7),
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                  ),

                                                  //  TextStyle(
                                                  //   fontSize: 12.0,
                                                  //   color: Colors.white,
                                                  // ),
                                                ),
                                          onTap: () {
                                            MyQueue.songs = songs;
                                            Navigator.of(context).push(
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new NowPlaying(
                                                            widget.db,
                                                            MyQueue.songs,
                                                            i,
                                                            0)));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      // ldcomc
                      : Container(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3.2,
                          ),
                          child: OutlineButton(
                            color: Colors.white,
                            highlightedBorderColor: Color(0xFF373737),
                            borderSide:
                                BorderSide(width: 1 , color: Colors.white),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("No Favourites Yet!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )
                                      // TextStyle(
                                      //   fontSize: 20.0,
                                      //   fontWeight: FontWeight.w600,
                                      //   color: Colors.white,
                                      // ),
                                      ),
                                  // Padding(
                                  //     padding:
                                  //         EdgeInsets.symmetric(vertical: 10.0)),
                                  SizedBox(
                                    height: 5,
                                  ),

                                  // Divider(),
                                  Text(
                                    "Start Adding Some",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),

                                    // TextStyle(
                                    //   fontSize: 15.0,
                                    //   fontWeight: FontWeight.w600,
                                    //   color: Colors.white,
                                    // ),
                                  ),
                                  // OutlineButton(
                                  //   child: Text(
                                  //     "Add Songs".toUpperCase(),
                                  //     style: TextStyle(color: Colors.white),
                                  //   ),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(8.0)),
                                  //   onPressed: _modelBottomSheet,
                                  //   color: Colors.white,
                                  //   highlightedBorderColor: Color(0xFF373737),
                                  //   borderSide:
                                  //       BorderSide(width: 2.0, color: Colors.white),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              )

        // floatingActionButton: songs != null
        //     ? FloatingActionButton(
        //         onPressed: () {
        //           _modelBottomSheet();
        //         },
        //         backgroundColor: Colors.white,
        //         foregroundColor: Colors.blueGrey,
        //         child: Icon(Icons.add))
        //     : null,
        ;
  }
}
