import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:test_player/data/song_data.dart';
import 'dart:math';

enum PlayerState { stopped, playing, paused }

class Songs with ChangeNotifier {
  List<Song> songgs = [];
  int _currentSongIndex;
  MusicFinder musicFinder;
  MusicFinder audioPlayer;
  // Songs songData;

  // Songs(this.songData);

  Songs(this.songgs) {
    {
      musicFinder = new MusicFinder();
    }
  }

  PlayerState playerState = PlayerState.stopped;

  int get length => songgsget.length;
  int get songNumber => _currentSongIndex + 1;
  int get currentIndex => _currentSongIndex;
  setCurrentIndex(int index) {
    _currentSongIndex = index;
  }

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

  Song get nextSong {
    if (_currentSongIndex > 0 && _currentSongIndex < length) {
      _currentSongIndex++;
    }
    if (_currentSongIndex >= length) return null;
    return songgs[_currentSongIndex];
  }

  Song get randomSong {
    Random r = new Random();
    return songgsget[r.nextInt(songgsget.length)];
  }

  Song get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    if (_currentSongIndex < 0) return null;
    return songgs[_currentSongIndex];
  }

  // MusicFinder get audioPlayer => musicFinder;

  List<Song> get songgsget => [...songgs];
}
