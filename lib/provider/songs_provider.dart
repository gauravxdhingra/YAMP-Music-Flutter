import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Songs with ChangeNotifier {
  List<Song> songgs = [];

  MusicFinder audioPlayer;

  playLocal(kurl) async {
    final result = await audioPlayer.play(kurl);
  }

  void initPlayer() async {
    audioPlayer = new MusicFinder();
    List<Song> _songs = await MusicFinder.allSongs();
    songgs = _songs;
    notifyListeners();

    //  List get songs => _songs;
    // songs = new List<Song>.from(_songs);
    // _songs = songs;
  }

  play(url) async {
    final result = await audioPlayer.play(url);
    // if (result == 1) setState(() => playerState = PlayerState.playing);
  }

  pause() async {
    final result = await audioPlayer.pause();
    // if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  stop() async {
    final result = await audioPlayer.stop();
    // if (result == 1) setState(() => playerState = PlayerState.stopped);
  }

  List<Song> get songgsget => [...songgs];
}
