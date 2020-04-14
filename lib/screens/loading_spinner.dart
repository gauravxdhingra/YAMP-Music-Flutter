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
  bool _isReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isReady) initPlayer();
    setState(() {
      _isReady = true;
    });
  }

  void initPlayer() async {
    audioPlayer = new MusicFinder();
    var _songs = await MusicFinder.allSongs();
    songs = new List<Song>.from(_songs);
    setState(() {
      _songs = songs;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(songs: _songs),
      ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   audioPlayer.stop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
