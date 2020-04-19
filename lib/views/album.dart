import 'dart:io';

import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:test_player/database/database_client.dart';
// import 'package:test_player/pages/card_detail.dart';
import 'package:test_player/pages/now_playing.dart';
import 'package:test_player/util/lastplay.dart';
import 'package:test_player/util/utility.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/card_detail.dart';
// import 'package:musicplayer/util/utility.dart';

class Album extends StatefulWidget {
  DatabaseClient db;
  Album(this.db);
  @override
  State<StatefulWidget> createState() {
    return new _stateAlbum();
  }
}

class _stateAlbum extends State<Album> {
  List<Song> songs;
  List<Song> filtersongs;
  var f;
  bool isLoading = true;
  @override
  initState() {
    initAlbum();
    super.initState();
  }

  void initAlbum() async {
    songs = await widget.db.fetchSongs();
    filtersongs = [];
    // filtersongs = await widget.db.searchSongByTitle('');
    // songs = await widget.db.fetchAlbum();
    setState(() {
      isLoading = false;
    });
  }

  // List<Card> _buildGridCards(BuildContext context) {
  //   final Orientation orientation = MediaQuery.of(context).orientation;
  //   return songs.map((song) {
  //     return Card(
  //       color: Colors.transparent,
  //       elevation: 8.0,
  //       child: new InkResponse(
  //         onTap: () {
  //           Navigator.of(context)
  //               .push(new MaterialPageRoute(builder: (context) {
  //             return new CardDetail(widget.db, song);
  //           }));
  //         },
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(6.0),
  //           child: Stack(
  //             children: <Widget>[
  //               Hero(
  //                 tag: song.album,
  //                 child: getImage(song) != null
  //                     ? Container(
  //                         color: Colors.blueGrey.shade300,
  //                         child: new Image.file(
  //                           getImage(song),
  //                           height: double.infinity,
  //                           fit: BoxFit.fitHeight,
  //                         ),
  //                       )
  //                     : new Image.asset(
  //                         "images/back.jpg",
  //                         height: double.infinity,
  //                         fit: BoxFit.fitHeight,
  //                       ),
  //               ),
  //               Positioned(
  //                 bottom: 0.0,
  //                 child: Container(
  //                   width: orientation == Orientation.portrait
  //                       ? (MediaQuery.of(context).size.width - 26.0) / 2
  //                       : (MediaQuery.of(context).size.width - 26.0) / 4,
  //                   color: Colors.white.withOpacity(0.88),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 7.0, right: 7.0),
  //                         child: Text(
  //                           song.album,
  //                           style: new TextStyle(
  //                               fontSize: 15.5,
  //                               color: Colors.black.withOpacity(0.8),
  //                               fontWeight: FontWeight.w600),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 5.0),
  //                         child: Padding(
  //                           padding: EdgeInsets.only(left: 7.0, right: 7.0),
  //                           child: Text(
  //                             song.artist,
  //                             maxLines: 1,
  //                             style: TextStyle(
  //                               fontSize: 14.0,
  //                               color: Colors.black.withOpacity(0.75),
  //                             ),
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(padding: EdgeInsets.symmetric(vertical: 4.0))
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }).toList();
  // }

  int returnIndex(Song songg) {
    for (int i = 0; i < songs.length; i++) {
      if (songg.id == songs[i].id) {
        return i;
      }
    }
    return 0;
  }

  TextEditingController tedit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      backgroundColor: Color(0xff7800ee),
      body: isLoading
          ? new Center(
              child: new CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Positioned(
                  top: MediaQuery.of(context).size.height / 22,
                  right: 15,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.14,
                    // padding: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Color(0xff6e00db),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(42),
                        bottomRight: Radius.circular(42),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              2.0, 2.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Container(
                      // color: Color(0xff7800ee),
                      padding: EdgeInsets.only(top: 7, left: 10, right: 10),
                      child: FloatingSearchBar.builder(
                        inputTextStyle: TextStyle(color: Colors.black),
                        SliverColor: Color(0xffFFCE00),
                        //  Color(0xff7800ee),
                        backgroundcolor: Color(0xff6e00db),
                        pinned: true,
                        // padding: EdgeInsets.only(top: 15),
                        body: null,
                        controller: tedit,
                        itemCount: filtersongs.length,
                        itemBuilder: (context, i) => ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.music_note),
                          ),
                          title: Text(
                            filtersongs[i].title,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            filtersongs[i].artist,
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            MyQueue.songs = songs;
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => new NowPlaying(
                                    widget.db,
                                    MyQueue.songs,
                                    returnIndex(filtersongs[i]),
                                    0)));
                          },
                        ),
                        leading: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        trailing: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                tedit.clear();
                                filtersongs = [];
                                // filtersongs = songs;
                                setState(() {});
                              }),
                        ),
                        onChanged: (String value) async {
                          if (value == '') {
                            filtersongs = [];
                          } else
                            filtersongs =
                                await widget.db.searchSongByTitle(value);
                          // print(filtersongs[0].title);
                          setState(() {});
                        },
                        // onTap: () {
                        //   MyQueue.songs = songs;
                        //   Navigator.of(context).push(new MaterialPageRoute(
                        //       builder: (context) =>
                        //           new NowPlaying(widget.db, MyQueue.songs, 0, 0)));
                        // },
                        decoration: InputDecoration.collapsed(
                            hintText: "Search Songs...",
                            // fillColor: Colors.white,
                            // focusColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.black,
                            )
                            // filled: true,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      // Positioned(
      //   top: 20,
      //   child: Scrollbar(
      //     child: new GridView.count(
      //       crossAxisCount:
      //           orientation == Orientation.portrait ? 2 : 4,
      //       children: _buildGridCards(context),
      //       physics: BouncingScrollPhysics(),
      //       padding: EdgeInsets.only(left: 10.0, right: 10.0),
      //       childAspectRatio: 8.0 / 9.5,
      //       crossAxisSpacing: 2.0,
      //       mainAxisSpacing: 18.0,
      //     ),
      //   ),
      // ),
    );
  }
}
