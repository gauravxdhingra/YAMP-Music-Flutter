import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:test_player/database/database_client.dart';
import 'package:test_player/pages/now_playing.dart';
import 'package:test_player/util/lastplay.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/now_playing.dart';
// import 'package:musicplayer/util/lastplay.dart';

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

  Widget recentW() {
    return new Container(
      height: 100.0,
      child: FutureBuilder(
        future: widget.db.fetchRecentSong(),
        builder: (context, AsyncSnapshot<List<Song>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              List<Song> recents = snapshot.data;
              return ListView.builder(
                itemCount: recents.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) => 
                InkWell(
                  onTap: () {
                    MyQueue.songs = recents;
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new NowPlaying(widget.db, recents, i, 0);
                    }));
                  }, //  ,
                  child: Hero(
                    tag: recents[i].id,
                    child: Container(
                      width: 250,
                      child: ListTile(
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
                                  child: Icon(Icons.music_note),
                                ),
                              ),
                        title: Text(
                          recents[i].title,
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                          // maxLines: 1,
                        ),
                        subtitle: Text(
                          recents[i].artist,
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                          // maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  // ),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height / 7.85,
            right: 15,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.25,
              // padding: EdgeInsets.only(left: 24, top: 24),
              decoration: BoxDecoration(
                color: Color(0xff6e00db),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Recents',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  recentW(),
                  Text(
                    'My Music',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
                            child: Container(
                              height: 500,
                              child: new ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: songs.length,
                                itemBuilder: (context, i) => new Column(
                                  children: <Widget>[
                                    new ListTile(
                                      leading: Hero(
                                        tag: songs[i].id,
                                        child: getImage(songs[i]) != null
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
                                                  child: Icon(Icons.music_note),
                                                ),
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
                                                    new NowPlaying(widget.db,
                                                        MyQueue.songs, i, 0)));
                                      },
                                    ),
                                  ],
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
