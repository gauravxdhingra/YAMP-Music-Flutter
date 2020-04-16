import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:test_player/data/song_data.dart';
import 'package:test_player/main_page.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:provider/provider.dart';
import '../provider/songs_provider.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:volume/volume.dart';

enum PlayerState { stopped, playing, paused }

class NowPlayingScreen extends StatefulWidget {
  static const routeName = '/now-playing';

  final Song song;
  final Songs songData;
  final bool nowPlayTap;

  NowPlayingScreen({this.song, this.songData, this.nowPlayTap});
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  List<int> soundBars = [];
  double barWidth = 5.0;
  double soundPosition = 0.0;
  double nextSoundPosition = 140.0;

  Random r = math.Random();

  static num currentVol = 0;
  // num initVol = 0;
  static num maxVol = 0;

  AudioManager audioManager;
  // int maxVol, currentVol;
  ShowVolumeUI showVolumeUI = ShowVolumeUI.SHOW;

  @override
  void initState() {
    super.initState();
    initPlayer();
    // for (int i = 0; i < 72; i++) {
    //   soundBars.add(r.nextInt((52)));
    // }

    audioManager = AudioManager.STREAM_MUSIC;
    initAudioStreamType();
    updateVolumes();
  }
// await Volume.controlVolume(AudioManager audioManager);

// await Volume.getMaxVol; await Volume.getVol;await Volume.setVol(int i, {ShowVolumeUI showVolumeUI});
  Future<void> initAudioStreamType() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {});
  }

  setVol(int i) async {
    await Volume.setVol(i, showVolumeUI: ShowVolumeUI.SHOW);
    // or
    // await Volume.setVol(i, showVolumeUI: ShowVolumeUI.HIDE);
  }

  final slider = SleekCircularSlider(
    appearance: CircularSliderAppearance(
      startAngle: 180,
      angleRange: 180,
      counterClockwise: true,
      size: 330,
      // customColors: CustomSliderColors(
      //   dotColor: Colors.black54,
      // ),
      customWidths: CustomSliderWidths(
          trackWidth: 3, handlerSize: 10, progressBarWidth: 10, shadowWidth: 5),
      // customColors: CustomSliderColors(),
    ),
    min: 0,
    max: maxVol.toDouble(),
    initialValue: currentVol.toDouble(),
    onChange: (double value) {
      // setVol(value.toInt());
      // updateVolumes();
      // changedvol(value);
      // callback providing a value while its being changed (with a pan gesture)
    },

    // innerWidget: (double value) {
    //   // use your custom widget inside the slider (gets a slider value from the callback)
    // },
  );

  // void changedvol(value) {
  //   setVol(value.toInt);
  // }

  PlayerState playerState;
  MusicFinder audioPlayer;
  Duration duration;
  Duration position;
  Song song;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
    play(widget.songData.nextSong);
  }

  initPlayer() async {
    if (audioPlayer == null) {
      audioPlayer = widget.songData.audioPlayer;
    }
    setState(() {
      song = widget.song;
      if (widget.nowPlayTap == null || widget.nowPlayTap == false) {
        if (playerState != PlayerState.stopped) {
          stop();
        }
      }
      play(song);
      //  else {
      //   widget._song;
      //   playerState = PlayerState.playing;
      // }
    });
    audioPlayer.setDurationHandler((d) => setState(() {
          duration = d;
        }));

    audioPlayer.setPositionHandler((p) => setState(() {
          position = p;
        }));

    audioPlayer.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
      });
    });

    audioPlayer.setErrorHandler((msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  var _currentSongIndex = -1;
  int get length => widget.songData.songgsget.length;
  int get songNumber => _currentSongIndex + 1;
  int get currentIndex => _currentSongIndex;

  Song get nextSong {
    if (_currentSongIndex < length) {
      _currentSongIndex++;
    }
    if (_currentSongIndex >= length) return null;
    return widget.songData.songgsget[_currentSongIndex];
  }

  Song get randomSong {
    Random r = new Random();
    return widget.songData.songgsget[r.nextInt(length)];
  }

  Song get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    if (_currentSongIndex < 0) return null;
    return widget.songData.songgsget[_currentSongIndex];
  }

  Future play(Song s) async {
    if (s != null) {
      final result = await audioPlayer.play(s.uri, isLocal: true);
      if (result == 1)
        setState(() {
          playerState = PlayerState.playing;
          song = s;
        });
    }
  }

  Future<dynamic> pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
    return result;
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future next(Songs songs) async {
    stop();
    setState(() {
      play(songs.nextSong);
    });
  }

  Future prev(Songs songs) async {
    stop();
    play(songs.prevSong);
  }

  Future random(Songs songs) async {
    stop();
    play(songs.randomSong);
  }

  Future mute(bool muted) async {
    final result = await audioPlayer.mute(muted);
    if (result == 1)
      setState(() {
        isMuted = muted;
      });
  }

  @override
  Widget build(BuildContext context) {
    // Songs songData = Provider.of<Songs>(context);
    // int i = 0;
    // backgroundColor: Colors.yellow,
    print(maxVol);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 16,
            right: 16,
            top: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Icon(Icons.favorite_border),
              ],
            ),
          ),
          Positioned(
            top: 70,
            left: MediaQuery.of(context).size.width / 2 - 165,
            child: slider,
          ),
          Positioned(
            left: 64,
            right: 64,
            top: 100,
            child: Container(
              height: 260,
              width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                // color: Colors.blue,
                shape: BoxShape.circle,
                image: song.albumArt == null
                    ? null
                    : DecorationImage(
                        image:
                            FileImage(File.fromUri(Uri.parse(song.albumArt))),
                        fit: BoxFit.cover,
                      ),
              ),
              // child: Center(
              //   child: CircleAvatar(
              //     radius: 24,
              //     // backgroundColor: Colors.yellow,
              //   ),
              // ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 500,
            child: Container(
              height: 180,
              child: Column(
                children: <Widget>[
                  Icon(Icons.music_note),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    // "Sam Fischer",
                    song.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    // "This City",
                    song.artist,
                    style: GoogleFonts.montserrat(),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    child: Slider(
                        value: position?.inMilliseconds?.toDouble() ?? 0,
                        onChanged: (double value) =>
                            audioPlayer.seek((value / 1000).roundToDouble()),
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble()),

                    // height: 52,
                    // child: Row(
                    //   children: soundBars.map((h) {
                    //     Color color = i >= soundPosition / barWidth &&
                    //             i <= nextSoundPosition / barWidth
                    //         ? Colors.yellow
                    //         : Colors.grey;
                    //     i++;
                    //     return Container(
                    //       margin: EdgeInsets.only(right: 1),
                    //       color: color,
                    //       height: h.toDouble(),
                    //       width: 4,
                    //     );
                    //   }).toList(),
                    // ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        positionText,
                        // "1:35",
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        // "3:42",
                        durationText,
                        // '${(duration.inSeconds / 60) .toStringAsFixed(0)} : ${(duration.inSeconds % 60)}',
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.refresh),
                    onPressed: () {}

                    //   soundBars.clear();
                    //   for (int i = 0; i < 72; i++) {
                    //     soundBars.add(r.nextInt((52)));
                    //   }
                    //   setState(() {});
                    // },
                    ),
                GestureDetector(
                    onTap: () => prev(widget.songData),
                    child: Icon(Icons.skip_previous)),
                GestureDetector(
                  onTap: isPlaying ? () => pause() : () => play(widget.song),
                  // songData.play(url),
                  child: Card(
                    color: backgroundColor,
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      height: 84,
                      width: 48,
                      child: Center(
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () => next(widget.songData),
                    child: Icon(Icons.skip_next)),
                GestureDetector(
                  onTap: () {},
                  // () => shuffleSongs(),
                  child: Icon(Icons.shuffle),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
