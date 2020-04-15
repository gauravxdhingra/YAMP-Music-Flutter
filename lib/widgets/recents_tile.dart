import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/songs_provider.dart';

class RecentsTile extends StatefulWidget {
  final int index;

  const RecentsTile({Key key, this.index}) : super(key: key);

  @override
  _RecentsTileState createState() => _RecentsTileState();
}

class _RecentsTileState extends State<RecentsTile> {
  // final index = 0;

  // static List<Song> _songs = [];
  @override
  void initState() {
    super.initState();
    // _songs = widget.songs;
    // widget.songs.forEach((ele) => _songs.add(ele));
    // print(_songs.length);
    // print(_songs[25].title);
  }

  @override
  Widget build(BuildContext context) {
    final songsData = Provider.of<Songs>(context);
    List<Song> _songs = songsData.songgsget;
    // int index = ModalRoute.of(context).settings.arguments as int;
    int index = widget.index;
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.yellow,
          backgroundImage: _songs[index].albumArt == null
              ? null
              : FileImage(File.fromUri(Uri.parse(_songs[index].albumArt))),
          // backgroundImage: (_songs[index].albumArt != null)
          //     ? NetworkImage(_songs[index].albumArt)
          //     : null,
        ),
        SizedBox(
          width: 12,
        ),
        Container(
          width: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                // "Secrets",
                _songs[index].title,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                // "Not a Hobby 2020",
                _songs[index].artist,
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade200,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        SizedBox(
          width: 24,
        ),
      ],
    );
  }
}
