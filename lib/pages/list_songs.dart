import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/pages/now_playing.dart';
// import 'package:musicplayer/util/AAppBar.dart';
// import 'package:musicplayer/util/lastplay.dart';
import 'package:flutter/cupertino.dart';
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

  void _modelBottomSheet() {
    List<bool> isFavorite = new List(allSongs.length);
    for (int m = 0; m < allSongs.length; m++) isFavorite[m] = false;
    bool isFavoriteX;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6.0),
                        topRight: Radius.circular(6.0))),
                color: Color(0xFFFAFAFA)),
            child: Scrollbar(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                itemCount: allSongs.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  isFavoriteX = true;
                  return ListTile(
                    title: Text(allSongs[i].title,
                        maxLines: 1,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        )),
                    leading: allSongs[i].albumArt != null
                        ? Image.file(
                            getImage(allSongs[i]),
                            width: 55.0,
                            height: 55.0,
                          )
                        : Icon(Icons.music_note),
                    subtitle: new Text(
                      allSongs[i].artist,
                      maxLines: 1,
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    trailing: RawMaterialButton(
                        shape: CircleBorder(),
                        child: !isFavorite[i] || isFavoriteX
                            ? Icon(Icons.add)
                            : Icon(Icons.remove),
                        fillColor: Color(0xFFefece8),
                        onPressed: () async {
                          setState(() {
                            isFavorite[i] = true;
                            isFavoriteX = false;
                          });
                          await widget.db.favSong(allSongs[i]);
                        }),
                    onTap: () {
                      MyQueue.songs = allSongs;
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) =>
                              new NowPlaying(widget.db, MyQueue.songs, i, 0)));
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    initSongs();
    // songs.sort((so));
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height / 15,
            right: 15,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.16,
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Color(0xff6e00db),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
              ),
              child: isLoading
                  ? new Center(
                      child: new CircularProgressIndicator(),
                    )
                  : songs.length != 0
                      ? Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
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
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 1.4,
                              child: new ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: songs.length,
                                itemBuilder: (context, i) => new Column(
                                  children: <Widget>[
                                    new ListTile(
                                      contentPadding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        // top: 5,
                                        // bottom: 5,
                                      ),
                                      leading: Hero(
                                        tag: songs[i].id,
                                        child: songs[i].albumArt != null
                                            ? CircleAvatar(
                                                backgroundImage: FileImage(
                                                  getImage(songs[i]),
                                                  // width: 55.0,
                                                  // height: 55.0,
                                                ),
                                              )
                                            : CircleAvatar(
                                                child: Center(
                                                  child: Text(songs[i]
                                                      .title[0]
                                                      .toUpperCase()),
                                                ),
                                              ),
                                      ),
                                      title: new Text(songs[i].title,
                                          maxLines: 1,
                                          style: new TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                      subtitle: new Text(
                                        songs[i].artist,
                                        maxLines: 1,
                                        style: new TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white),
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
                          ],
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
                              OutlineButton(
                                child: Text("Add Songs".toUpperCase()),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                onPressed: _modelBottomSheet,
                                color: Colors.blueGrey.shade500,
                                highlightedBorderColor: Color(0xFF373737),
                                borderSide: BorderSide(
                                    width: 2.0, color: Colors.blueGrey),
                              )
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: songs != null
          ? FloatingActionButton(
              onPressed: () {
                _modelBottomSheet();
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueGrey,
              child: Icon(Icons.add))
          : null,
    );
  }
}
