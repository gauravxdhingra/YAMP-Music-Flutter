import 'dart:async';
import 'dart:math';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_player/database/database_client.dart';
import 'package:test_player/pages/list_songs.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/list_songs.dart';

class Playlist extends StatefulWidget {
  final DatabaseClient db;
  Playlist(this.db);

  @override
  State<StatefulWidget> createState() {
    return new _StatePlaylist();
  }
}

class _StatePlaylist extends State<Playlist> {
  var mode;
  List<Song> songs;
  var selected;
  String atFirst, atSecond, atThir;
  String nu = "null";
  Orientation orientation;
  @override
  void initState() {
    super.initState();
    _lengthFind();
    setState(() {});
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
      atFirst = songs[random.nextInt(songs.length - 1)].artist;
    });
    songs = await widget.db.fetchTopSong();
    setState(() {
      atSecond = songs[random.nextInt(songs.length - 1)].artist;
    });
    songs = await widget.db.fetchFavSong();
    String atThird = "No Songs in favorites";
    setState(() {
      atThir = songs.length != 0
          ? "Includes ${songs[random.nextInt(songs.length - 1)].artist.toString()} and more"
          : atThird;
    });
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return new Container(
      child: portrait(),
    );
  }

  Widget portrait() {
    return new ListSongs(widget.db, 3, Orientation.portrait);
  }
}
