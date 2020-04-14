import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main_page.dart';
import 'package:provider/provider.dart';
import '../provider/songs_provider.dart';

class RecentsTile extends StatefulWidget {
  @override
  _RecentsTileState createState() => _RecentsTileState();
}

class _RecentsTileState extends State<RecentsTile> {
  final index = 0;

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
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.yellow,
        ),
        SizedBox(
          width: 12,
        ),
        Column(
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
              overflow: TextOverflow.clip,
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
              overflow: TextOverflow.fade,
            )
          ],
        ),
        SizedBox(
          width: 24,
        ),
      ],
    );
  }
}
