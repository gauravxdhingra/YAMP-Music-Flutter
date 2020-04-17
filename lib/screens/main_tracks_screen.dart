import 'dart:io';

// import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
import 'package:test_player/db/database_client.dart';
// import 'package:test_player/provider/songs_provider.dart';
import 'package:test_player/screens/now_playing_screen.dart';
import 'package:test_player/support/lastplay.dart';
// import '../widgets/music_tile.dart';
// import '../widgets/recents_tile.dart';

class MainTracksScreen extends StatefulWidget {
  final DatabaseClient db;

  MainTracksScreen(this.db);

  @override
  _MainTracksScreenState createState() => _MainTracksScreenState();
}

class _MainTracksScreenState extends State<MainTracksScreen> {
  List<Song> songs, allSongs;
  bool isLoading = true;

  // final _controller = ScrollController();
  // final _controller1 = ScrollController();
// List<Song> tracks = widget.songs;
  // static List<Song> _songs;

  // @override
  // void initState() {
  //   super.initState();
  //   _songs = widget.songs;
  //   print(_songs.length);
  // }

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
    songs = await widget.db.fetchRecentSong();
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

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                child: isLoading
                    ? new Center(
                        child: new CircularProgressIndicator(),
                      )
                    : songs.length != 0
                        ? new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: songs.length,
                            itemBuilder: (context, i) => new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Hero(
                                    tag: songs[i].id,
                                    child: songs[i].albumArt != null
                                        ? Image.file(
                                            getImage(songs[i]),
                                            width: 55.0,
                                            height: 55.0,
                                          )
                                        : Icon(Icons.music_note),
                                  ),
                                  title: new Text(songs[i].title,
                                      maxLines: 1,
                                      style: new TextStyle(
                                          fontSize: 16.0, color: Colors.black)),
                                  subtitle: new Text(
                                    songs[i].artist,
                                    maxLines: 1,
                                    style: new TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                  trailing: Text(
                                      new Duration(
                                              milliseconds: songs[i].duration)
                                          .toString()
                                          .split('.')
                                          .first
                                          .substring(3, 7),
                                      style: new TextStyle(
                                          fontSize: 12.0, color: Colors.grey)),
                                  onTap: () {
                                    MyQueue.songs = songs;
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new NowPlayingScreen(widget.db,
                                                    MyQueue.songs, i, 0)));
                                  },
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Nothing here :(",
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0)),
                              ],
                            ),
                          ),
              ),

              // Container(
              //   height: MediaQuery.of(context).size.height / 11,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: <Widget>[
              //       Container(
              //         margin: EdgeInsets.only(top: 16, left: 0),
              //         width: MediaQuery.of(context).size.width / 1.2,
              //         //  decoration: BoxDecoration(color: Colors.yellow),
              //         child: FadingEdgeScrollView.fromScrollView(
              //           gradientFractionOnStart: 0.05,
              //           gradientFractionOnEnd: 0.03,
              //           child: ListView.builder(
              //             controller: _controller,
              //             physics: BouncingScrollPhysics(),
              //             scrollDirection: Axis.horizontal,
              //             padding: EdgeInsets.zero,
              //             itemCount: _songs.length,
              //             itemBuilder: (BuildContext context, int index) {
              //               return Container(
              //                 height: 84,
              //                 margin: EdgeInsets.only(bottom: 18),
              //                 child: RecentsTile(
              //                   index: index,
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
                // height: MediaQuery.of(context).size.height / 1.7415,
                height: MediaQuery.of(context).size.height / 1.7415,
                // + MediaQuery.of(context).size.height / 12.85,

                width: MediaQuery.of(context).size.width / 1.15,
                // decoration: BoxDecoration(color: Colors.yellow),
                // child: Text('data'),
                child: isLoading
                    ? new Center(
                        child: new CircularProgressIndicator(),
                      )
                    :
                    // FadingEdgeScrollView.fromScrollView(
                    //   gradientFractionOnStart: 0.04,
                    //   gradientFractionOnEnd: 0.02,
                    //   child:
                    FutureBuilder(
                  future: widget.db.fetchSongs(),
                  builder: (context, AsyncSnapshot<List<Song>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        break;
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      case ConnectionState.active:
                        break;
                      case ConnectionState.done:
                        List<Song> songs = snapshot.data;
                        return Scrollbar(
                          child: new ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: songs.length,
                            itemBuilder: (context, i) => new Column(
                              children: <Widget>[
                                new ListTile(
                                  leading: Hero(
                                      tag: songs[i].id,
                                      child: getImage(songs[i]) != null
                                          ? Image.file(
                                              getImage(songs[i]),
                                              width: 55.0,
                                              height: 55.0,
                                              // TODO :  Check here
                                            )
                                          : Icon(Icons.music_note)),
                                  title: new Text(songs[i].title,
                                      maxLines: 1,
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      )),
                                  subtitle: new Text(
                                    songs[i].artist,
                                    maxLines: 1,
                                    style: new TextStyle(
                                        fontSize: 12.0, color: Colors.grey),
                                  ),
                                  trailing: new Text(
                                      new Duration(
                                              milliseconds: songs[i].duration)
                                          .toString()
                                          .split('.')
                                          .first
                                          .substring(3, 7),
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black54)),
                                  onTap: () {
                                    MyQueue.songs = songs;
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (context) => NowPlayingScreen(
                                          widget.db,
                                          MyQueue.songs,
                                          i,
                                          0,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                    }
                    return Text('end');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // ListView.builder(
//                     controller: _controller1,
//                     physics: BouncingScrollPhysics(),
//                     padding: EdgeInsets.zero,
//                     itemCount: _songs.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin: EdgeInsets.only(bottom: 11),
//                         width: MediaQuery.of(context).size.width / 1.3,
//                         decoration: BoxDecoration(
//                             // color: Colors.purple,
//                             ),
//                         child: GestureDetector(
//                           onTap: () {
//                             songsData.setCurrentIndex(index);
//                             goToNowPlaying(
//                               _songs[index],
//                             );
//                           },
//                           // {songsData.playLocal(_songs[index].uri)},
//                           child: MusicTile(
//                             index: index,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     )

    // @override
    // void dispose() {
    //   _controller.dispose();
    //   _controller1.dispose();
    //   super.dispose();
    // }

//   @override
//   Widget build(BuildContext context) {
//     final songsData = Provider.of<Songs>(context);
//     List<Song> _songs = songsData.songgsget;
//     return
// //          6e00db
//     Positioned(
//       top: MediaQuery.of(context).size.height / 7.85,
//       right: 15,
//       left: 0,
//       child: Container(
//         height: MediaQuery.of(context).size.height / 1.27,
//         padding: EdgeInsets.only(left: 24, top: 24),
//         decoration: BoxDecoration(
//           color: Color(0xff6e00db),
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(42),
//             bottomRight: Radius.circular(42),

//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             // mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 "Recent Songs",
//                 style: GoogleFonts.montserrat(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600),
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height / 11,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.only(top: 16, left: 0),
//                       width: MediaQuery.of(context).size.width / 1.2,
//                       //  decoration: BoxDecoration(color: Colors.yellow),
//                       child: FadingEdgeScrollView.fromScrollView(
//                         gradientFractionOnStart: 0.05,
//                         gradientFractionOnEnd: 0.03,
//                         child: ListView.builder(
//                           controller: _controller,
//                           physics: BouncingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           padding: EdgeInsets.zero,
//                           itemCount: _songs.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                               height: 84,
//                               margin: EdgeInsets.only(bottom: 18),
//                               child: RecentsTile(
//                                 index: index,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 24),
//                 child: Divider(
//                   thickness: 2,
//                   color: Color(0xff7800ee),
//                 ),
//               ),
//               SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 "My Music",
//                 style: GoogleFonts.montserrat(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 16, left: 0),
//                 // height: MediaQuery.of(context).size.height / 1.7415,
//                 height: MediaQuery.of(context).size.height / 1.7415,
//                 // + MediaQuery.of(context).size.height / 12.85,

//                 width: MediaQuery.of(context).size.width / 1.15,
//                 // decoration: BoxDecoration(color: Colors.yellow),
//                 // child: Text('data'),
//                 child: FadingEdgeScrollView.fromScrollView(
//                   gradientFractionOnStart: 0.04,
//                   gradientFractionOnEnd: 0.02,
//                   child: ListView.builder(
//                     controller: _controller1,
//                     physics: BouncingScrollPhysics(),
//                     padding: EdgeInsets.zero,
//                     itemCount: _songs.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Container(
//                         margin: EdgeInsets.only(bottom: 11),
//                         width: MediaQuery.of(context).size.width / 1.3,
//                         decoration: BoxDecoration(
//                             // color: Colors.purple,
//                             ),
//                         child: GestureDetector(
//                           onTap: () {
//                             songsData.setCurrentIndex(index);
//                             goToNowPlaying(
//                               _songs[index],
//                             );
//                           },
//                           // {songsData.playLocal(_songs[index].uri)},
//                           child: MusicTile(
//                             index: index,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
  }
}

// class CustomSearchDelegate extends SearchDelegate {
//   List<String> searchList = [];

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     List<Song> listSongs = Provider.of<Songs>(context).songgsget;
//     listSongs.forEach((ele) {
//       searchList.add(ele.title);
//     });

//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       //  Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Column(
//       children: <Widget>[],
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestionList = query.isEmpty
//         ? []
//         : searchList.where((p) => p.contains(query)).toList();
//     return ListView.builder(
//       itemCount: suggestionList.length,
//       itemBuilder: (BuildContext context, int index) {
//         return ListTile(
//           leading: Icon(Icons.music_note),
//           title: Text(suggestionList[index]),
//         );
//       },
//     );
//   }
// }
