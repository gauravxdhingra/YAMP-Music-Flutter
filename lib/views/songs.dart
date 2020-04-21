import 'dart:io';

import 'package:draggable_scrollbar_sliver/draggable_scrollbar_sliver.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_player/database/database_client.dart';
import 'package:test_player/pages/now_playing.dart';
import 'package:test_player/util/lastplay.dart';
import 'package:floating_search_bar/floating_search_bar.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/now_playing.dart';
// import 'package:musicplayer/util/lastplay.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';

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

  Widget recentW(_controllerh) {
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
                  color: Colors.blueGrey,
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
                    }, //  ,
                    child: Container(
                      // tag: recents[i].id,
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
                                child: Center(
                                  child:
                                      Text(recents[i].title[0].toUpperCase()),
                                ),
                              ),
                        title: Text(
                          recents[i].title,
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          recents[i].artist,
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
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
    return Scaffold(
      backgroundColor: Color(0xff7800ee),
      //  Colors.transparent,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height / 22,
            right: 10,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.142,
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Color(0xff6e00db),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.5,
                    spreadRadius: 0.5,
                    offset: Offset(0.5, 0.5), // shadow direction: bottom right
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Recents',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  recentW(_controllerh),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Color(0xff7800ee),
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    child: Text(
                      'My Music',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
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
                            height: 400,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 250,
                                ),
                                SpinKitThreeBounce(
                                  color: Colors.blueGrey,
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
                            labelTextBuilder: (double offset) =>
                                Text("${offset ~/ 100}"),
                            // alwaysVisibleScrollThumb: true,
                            scrollbarTimeToFade: Duration(seconds: 2),
                            controller: _controller,
                            heightScrollThumb: 45,
                            backgroundColor: Color(0xffFFCE00),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height / 1.448,
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
                                                    // TODO :  Check here
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  child: Center(
                                                    child: Text(songs[i]
                                                        .title[0]
                                                        .toUpperCase()),
                                                  ),
                                                ),
                                          title: new Text(songs[i].title,
                                              maxLines: 1,
                                              style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              )),
                                          subtitle: new Text(
                                            songs[i].artist,
                                            maxLines: 1,
                                            style: new TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          trailing: new Text(
                                              new Duration(
                                                      milliseconds:
                                                          songs[i].duration)
                                                  .toString()
                                                  .split('.')
                                                  .first
                                                  .substring(3, 7),
                                              style: new TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
