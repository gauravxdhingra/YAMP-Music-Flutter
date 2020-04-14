import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_player/data/song_data.dart';

enum PlayerState { stopped, playing, paused }

class Songs with ChangeNotifier {
  List<Song> songgs = [];

  MusicFinder audioPlayer;
   SongData songData;
  PlayerState playerState = PlayerState.stopped;

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

  List<Song> get songgsget => [...songgs];
}
