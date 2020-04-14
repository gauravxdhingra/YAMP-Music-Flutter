import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test_player/main_page.dart';

class LoadingScreen extends StatefulWidget {
  // // const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  MusicFinder audioPlayer;
  List<Song> songs;
  @override
  void initState() async {
    initPlayer();
    super.initState();
    
  }

  void initPlayer() async {
    audioPlayer = new MusicFinder();
    var _songs = await MusicFinder.allSongs();
    songs = new List<Song>.from(songs);
    setState(() {
      _songs = songs;
    });
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => MainPage(songs: _songs),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
