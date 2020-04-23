import 'dart:io';

import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_player/database/database_client.dart';
import 'package:test_player/pages/now_playing.dart';
import 'package:test_player/util/lastplay.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/now_playing.dart';
// import 'package:musicplayer/util/lastplay.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class Songs extends StatefulWidget {
  final DatabaseClient db;

  Songs(this.db);

  @override
  State<StatefulWidget> createState() {
    return new SongsState();
  }
}

class SongsState extends State<Songs> {
  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget recentW(_controllerh, _theme) {
    return new Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: FutureBuilder(
        future: widget.db.fetchRecentSong(),
        builder: (context, AsyncSnapshot<List<Song>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: SpinKitThreeBounce(
                  color: _theme.darkMode
                      ? Colors.blueGrey
                      : Theme.of(context).bottomAppBarColor,
                  size: 20,
                ),
              );
            // CircularProgressIndicator();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              List<Song> recents = snapshot.data;
              return FadingEdgeScrollView.fromScrollView(
                gradientFractionOnStart: 0.07,
                gradientFractionOnEnd: 0.07,
                child: ListView.builder(
                  itemCount: 10,
                  controller: _controllerh,
                  //  recents.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) => InkWell(
                    onTap: () {
                      MyQueue.songs = recents;
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new NowPlaying(widget.db, recents, i, 0);
                      }));
                    }, //
                    child: Container(
                      //  tag: recents[i].id,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                          left: 10,
                        ),
                        leading: getImage(recents[i]) != null
                            ? CircleAvatar(
                                child: Container(
                                  // height: 120.0,
                                  // width: 180.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(
                                        getImage(recents[i]),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: _theme.darkMode
                                    ? Theme.of(context).bottomAppBarColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                child: Center(
                                  child: Text(
                                    recents[i].title[0].toUpperCase(),
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ),
                              ),
                        title: Hero(
                          tag: recents[i].id,
                          child: Text(
                            recents[i].title,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 15.0,
                              // fontWeight: FontWeight.w500,
                            ),
                            // TextStyle(
                            //   color: Colors.white,
                            //   fontSize: 16.0,
                            //   fontWeight: FontWeight.w500,
                            // ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        subtitle: Text(
                          recents[i].artist,
                          style: GoogleFonts.montserrat(
                              fontSize: 12.0, color: Colors.white),

                          // TextStyle(fontSize: 12.0, color: Colors.white),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    // ),
                  ),
                ),
              );
          }
          return Text('end');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();
    final _controllerh = ScrollController();
    final _theme = Provider.of<ThemeModel>(context);

    // backgroundColor: Color(0xff7800ee),
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.history,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'RECENTS',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // letterSpacing: 1.2,
                ),
                //  TextStyle(
                //   fontSize: 20,
                //   fontWeight: FontWeight.bold,
                //   color: Colors.white,
                //   letterSpacing: 1.2,
                // ),
              ),
            ],
          ),
        ),
        recentW(_controllerh, _theme),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: _theme.darkMode
                ? Theme.of(context).textTheme.headline.color
                : Color(0xff6e00db),
            // Color(0xff7800ee),
            thickness: _theme.darkMode ? 0.3 : 2.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.queue_music,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text('MY MUSIC',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // letterSpacing: 1.2,
                  )
                  // TextStyle(
                  //   fontSize: 20,
                  //   fontWeight: FontWeight.bold,
                  //   color: Colors.white,
                  //   letterSpacing: 1.2,
                  // ),
                  ),
            ],
          ),
        ),
        FutureBuilder(
          future: widget.db.fetchSongs(),
          builder: (context, AsyncSnapshot<List<Song>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Container(
                  height: MediaQuery.of(context).size.height > 650 ? 400 : 300,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height > 650
                            ? 250
                            : 170,
                      ),
                      SpinKitThreeBounce(
                        color: _theme.darkMode
                            ? Colors.blueGrey
                            : Theme.of(context).bottomAppBarColor,
                        size: 20,
                      ),
                    ],
                  ),
                );
              //  CircularProgressIndicator();
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                List<Song> songs = snapshot.data;
                return DraggableScrollbar.rrect(
                  labelTextBuilder: (double offset) => Text("${offset ~/ 100}"),
                  // alwaysVisibleScrollThumb: true,
                  scrollbarTimeToFade: Duration(seconds: 2),
                  controller: _controller,
                  heightScrollThumb: 55,
                  backgroundColor: Theme.of(context).backgroundColor,
                  // Color(0xffFFCE00),
                  child: Container(
                    height: MediaQuery.of(context).size.height > 650
                        ? MediaQuery.of(context).size.height / 1.495
                        : MediaQuery.of(context).size.height / 1.73,
                    child: FadingEdgeScrollView.fromScrollView(
                      gradientFractionOnStart: 0.05,
                      gradientFractionOnEnd: 0.03,
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          top: 5,
                          right: 5,
                          bottom: 5,
                        ),
                        physics: BouncingScrollPhysics(),
                        controller: _controller,
                        itemCount: songs.length,
                        itemBuilder: (context, i) => new Column(
                          children: <Widget>[
                            Container(
                              height: 70,
                              child: ListTile(
                                contentPadding: EdgeInsets.only(
                                  left: 20,
                                  right: 30,
                                  top: 5,
                                  bottom: 5,
                                ),
                                leading: getImage(songs[i]) != null
                                    //  tag: songs[i].id,
                                    ? CircleAvatar(
                                        backgroundImage: FileImage(
                                          getImage(songs[i]),
                                          // fit: BoxFit.cover,
                                          // width: 55.0,
                                          // height: 55.0,
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: _theme.darkMode
                                            ? Theme.of(context)
                                                .bottomAppBarColor
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        child: Center(
                                          child: Text(
                                              songs[i].title[0].toUpperCase()),
                                        ),
                                      ),
                                title: Hero(
                                  tag: songs[i],
                                  transitionOnUserGestures: true,
                                  child: Text(songs[i].title,
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      )

                                      // new TextStyle(
                                      //   color: Colors.white,
                                      //   fontSize: 16.0,
                                      // )
                                      ),
                                ),
                                subtitle: new Text(
                                  songs[i].artist,
                                  maxLines: 1,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),

                                  // new TextStyle(
                                  //   fontSize: 12.0,
                                  //   color: Colors.white,
                                  // ),
                                ),
                                trailing: new Text(
                                  new Duration(milliseconds: songs[i].duration)
                                      .toString()
                                      .split('.')
                                      .first
                                      .substring(3, 7),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 12.0, color: Colors.white),
                                ),
                                // TextStyle(
                                //     fontSize: 12.0, color: Colors.white)),
                                onTap: () {
                                  MyQueue.songs = songs;
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (context) => new NowPlaying(
                                              widget.db, MyQueue.songs, i, 0)));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }
            return Text('end');
          },
        ),
      ],
    );
  }
}
