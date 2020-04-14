import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:test_player/provider/songs_provider.dart';

import '../main_page.dart';

class LoadingScreen extends StatefulWidget {
  // // const LoadingScreen({Key key}) : super(key: key);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  MusicFinder audioPlayer;
  List<Song> songs;
  bool _isReady = false;

  // void initPlayer() async {
  //   audioPlayer = new MusicFinder();
  //   List<Song> _songs = await MusicFinder.allSongs();
  //   songs = new List<Song>.from(_songs);
  //   setState(() {
  //     _songs = songs;
  //   });
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MainPage(songs),
  //     ),
  //   );
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   audioPlayer.stop();
  // }

  @override
  void didChangeDependencies() {
    if (_isReady) Navigator.pushReplacementNamed(context, MainPage.routeName);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final songData = Provider.of<Songs>(context);
    songData.initPlayer();
    _isReady = true;
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
