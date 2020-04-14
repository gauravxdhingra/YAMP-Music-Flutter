import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main_page.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:provider/provider.dart';
import '../provider/songs_provider.dart';

class MusicTile extends StatelessWidget {
  final int index = 0;

  @override
  Widget build(BuildContext context) {
    final songsData = Provider.of<Songs>(context);
    List<Song> _songs = songsData.songgsget;

    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 24,
          // child:
          //     Image.network(_songs[index].albumArt),
        ),
        SizedBox(
          width: 12,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
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
        )
      ],
    );
  }
}
