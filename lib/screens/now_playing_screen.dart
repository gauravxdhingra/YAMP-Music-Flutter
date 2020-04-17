import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_player/db/database_client.dart';
// import 'package:test_player/data/song_data.dart';
import 'package:test_player/main_page.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:provider/provider.dart';
import 'package:test_player/support/lastplay.dart';
// import '../provider/songs_provider.dart';
import 'package:flute_music_player/flute_music_player.dart';
// import 'package:volume/volume.dart';

enum PlayerState { stopped, playing, paused }

class NowPlayingScreen extends StatefulWidget {
  static const routeName = '/now-playing';

  final int mode;
  final List<Song> songs;
  int index;
  final DatabaseClient db;

  NowPlayingScreen(this.db, this.songs, this.index, this.mode);
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  MusicFinder player;
  Duration duration;
  Duration position;
  bool isPlaying = false;
  Song song;
  int isFav = 1;
  int repeatOn = 0;
  Orientation orientation;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  bool isOpened = true;
  Animation<double> _animateIcon;
  Timer timer;
  bool _showArtistImage;

  get durationText => duration != null
      ? duration.toString().split('.').first.substring(3, 7)
      : '';

  get positionText => position != null
      ? position.toString().split('.').first.substring(3, 7)
      : '';

  @override
  void initState() {
    super.initState();
    _showArtistImage = false;
    initAnim();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  initAnim() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.blueGrey[400].withOpacity(0.7),
      end: Colors.blueGrey[400].withOpacity(0.9),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
  }

  animateForward() {
    _animationController.forward();
  }

  animateReverse() {
    _animationController.reverse();
  }

  void initPlayer() async {
    if (player == null) {
      player = MusicFinder();
      MyQueue.player = player;
      var pref = await SharedPreferences.getInstance();
      pref.setBool("played", true);
    }
    //  int i= await widget.db.isfav(song);
    setState(() {
      if (widget.mode == 0) {
        player.stop();
      }
      updatePage(widget.index);
      isPlaying = true;
    });
    player.setDurationHandler((d) => setState(() {
          duration = d;
        }));
    player.setPositionHandler((p) => setState(() {
          position = p;
        }));
    player.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
        if (repeatOn != 1) ++widget.index;
        song = widget.songs[widget.index];
      });
    });
    player.setErrorHandler((msg) {
      setState(() {
        player.stop();
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  void updatePage(int index) {
    MyQueue.index = index;
    song = widget.songs[index];
    song.timestamp = new DateTime.now().millisecondsSinceEpoch;
    if (song.count == null) {
      song.count = 0;
    } else {
      song.count++;
    }
    widget.db.updateSong(song);
    isFav = song.isFav;
    player.play(song.uri);
    animateReverse();
    setState(() {
      isPlaying = true;
    });
  }

  void playPause() {
    if (isPlaying) {
      player.pause();
      animateForward();
      setState(() {
        isPlaying = false;
        //  song = widget.songs[widget.index];
      });
    } else {
      player.play(song.uri);
      animateReverse();
      setState(() {
        //song = widget.songs[widget.index];
        isPlaying = true;
      });
    }
  }

  Future next() async {
    player.stop();
    // int i=await widget.db.isfav(song);
    setState(() {
      int i = widget.index + 1;
      if (repeatOn != 1) ++widget.index;

      if (i >= widget.songs.length) {
        i = widget.index = 0;
      }

      updatePage(widget.index);
    });
  }

  Future prev() async {
    player.stop();
    //   int i=await  widget.db.isfav(song);
    setState(() {
      int i = --widget.index;
      if (i < 0) {
        widget.index = 0;
        i = widget.index;
      }
      updatePage(i);
    });
  }

  void onComplete() {
    next();
  }

  dynamic getImage(Song song) {
    if (song.albumArt == null) return null;
    return song == null ? null : new File.fromUri(Uri.parse(song.albumArt));
  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
//   List<int> soundBars = [];
//   double barWidth = 5.0;
//   double soundPosition = 0.0;
//   double nextSoundPosition = 140.0;

//   Random r = math.Random();

//   static num currentVol = 0;
//   // num initVol = 0;
//   static num maxVol = 0;

//   AudioManager audioManager;
//   // int maxVol, currentVol;
//   ShowVolumeUI showVolumeUI = ShowVolumeUI.SHOW;

//   @override
//   void initState() {
//     super.initState();
//     initPlayer();
//     // for (int i = 0; i < 72; i++) {
//     //   soundBars.add(r.nextInt((52)));
//     // }

//     audioManager = AudioManager.STREAM_MUSIC;
//     initAudioStreamType();
//     updateVolumes();
//   }
// // await Volume.controlVolume(AudioManager audioManager);

// // await Volume.getMaxVol; await Volume.getVol;await Volume.setVol(int i, {ShowVolumeUI showVolumeUI});
//   Future<void> initAudioStreamType() async {
//     await Volume.controlVolume(AudioManager.STREAM_MUSIC);
//   }

//   updateVolumes() async {
//     // get Max Volume
//     maxVol = await Volume.getMaxVol;
//     // get Current Volume
//     currentVol = await Volume.getVol;
//     setState(() {});
//   }

//   setVol(int i) async {
//     await Volume.setVol(i, showVolumeUI: ShowVolumeUI.SHOW);
//     // or
//     // await Volume.setVol(i, showVolumeUI: ShowVolumeUI.HIDE);
//   }

//   final slider = SleekCircularSlider(
//     appearance: CircularSliderAppearance(
//       startAngle: 180,
//       angleRange: 180,
//       counterClockwise: true,
//       size: 330,
//       // customColors: CustomSliderColors(
//       //   dotColor: Colors.black54,
//       // ),
//       customWidths: CustomSliderWidths(
//           trackWidth: 3, handlerSize: 10, progressBarWidth: 10, shadowWidth: 5),
//       // customColors: CustomSliderColors(),
//     ),
//     min: 0,
//     max: maxVol.toDouble(),
//     initialValue: currentVol.toDouble(),
//     onChange: (double value) {
//       // setVol(value.toInt());
//       // updateVolumes();
//       // changedvol(value);
//       // callback providing a value while its being changed (with a pan gesture)
//     },

//     // innerWidget: (double value) {
//     //   // use your custom widget inside the slider (gets a slider value from the callback)
//     // },
//   );

//   // void changedvol(value) {
//   //   setVol(value.toInt);
//   // }

//   PlayerState playerState;
//   MusicFinder audioPlayer;
//   Duration duration;
//   Duration position;
//   Song song;

//   get isPlaying => playerState == PlayerState.playing;
//   get isPaused => playerState == PlayerState.paused;

//   get durationText =>
//       duration != null ? duration.toString().split('.').first : '';
//   get positionText =>
//       position != null ? position.toString().split('.').first : '';

//   bool isMuted = false;

//   void onComplete() {
//     setState(() => playerState = PlayerState.stopped);
//     play(widget.songData.nextSong);
//   }

//   initPlayer() async {
//     if (audioPlayer == null) {
//       audioPlayer = widget.songData.audioPlayer;
//     }
//     setState(() {
//       song = widget.song;
//       if (widget.nowPlayTap == null || widget.nowPlayTap == false) {
//         if (playerState != PlayerState.stopped) {
//           stop();
//         }
//       }
//       play(song);
//       //  else {
//       //   widget._song;
//       //   playerState = PlayerState.playing;
//       // }
//     });
//     audioPlayer.setDurationHandler((d) => setState(() {
//           duration = d;
//         }));

//     audioPlayer.setPositionHandler((p) => setState(() {
//           position = p;
//         }));

//     audioPlayer.setCompletionHandler(() {
//       onComplete();
//       setState(() {
//         position = duration;
//       });
//     });

//     audioPlayer.setErrorHandler((msg) {
//       setState(() {
//         playerState = PlayerState.stopped;
//         duration = new Duration(seconds: 0);
//         position = new Duration(seconds: 0);
//       });
//     });
//   }

//   var _currentSongIndex = -1;
//   int get length => widget.songData.songgsget.length;
//   int get songNumber => _currentSongIndex + 1;
//   int get currentIndex => _currentSongIndex;

//   Song get nextSong {
//     if (_currentSongIndex < length) {
//       _currentSongIndex++;
//     }
//     if (_currentSongIndex >= length) return null;
//     return widget.songData.songgsget[_currentSongIndex];
//   }

//   Song get randomSong {
//     Random r = new Random();
//     return widget.songData.songgsget[r.nextInt(length)];
//   }

//   Song get prevSong {
//     if (_currentSongIndex > 0) {
//       _currentSongIndex--;
//     }
//     if (_currentSongIndex < 0) return null;
//     return widget.songData.songgsget[_currentSongIndex];
//   }

//   Future play(Song s) async {
//     if (s != null) {
//       final result = await audioPlayer.play(s.uri, isLocal: true);
//       if (result == 1)
//         setState(() {
//           playerState = PlayerState.playing;
//           song = s;
//         });
//     }
//   }

//   Future<dynamic> pause() async {
//     final result = await audioPlayer.pause();
//     if (result == 1) setState(() => playerState = PlayerState.paused);
//     return result;
//   }

//   Future stop() async {
//     final result = await audioPlayer.stop();
//     if (result == 1)
//       setState(() {
//         playerState = PlayerState.stopped;
//         position = new Duration();
//       });
//   }

//   Future next(Songs songs) async {
//     stop();
//     setState(() {
//       play(songs.nextSong);
//     });
//   }

//   Future prev(Songs songs) async {
//     stop();
//     play(songs.prevSong);
//   }

//   Future random(Songs songs) async {
//     stop();
//     play(songs.randomSong);
//   }

//   Future mute(bool muted) async {
//     final result = await audioPlayer.mute(muted);
//     if (result == 1)
//       setState(() {
//         isMuted = muted;
//       });
//   }

  @override
  Widget build(BuildContext context) {
    // Songs songData = Provider.of<Songs>(context);
    // int i = 0;
    // backgroundColor: Colors.yellow,
    return Scaffold(
      body: song == null
          ? Stack(
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
                  left: 64,
                  right: 64,
                  top: 100,
                  child: Container(
                    height: 260,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: getImage(song) != null
                        ? Image.file(
                            getImage(song),
                            fit: BoxFit.fitHeight,
                          )
                        : Image.asset(
                            "images/music.jpg",
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width,
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
                          // song.title,
                          '${song.title}',
                          style: GoogleFonts.montserrat(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          // "This City",
                          // song.artist,
                          "${song.artist}",
                          style: GoogleFonts.montserrat(),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          child: Slider(
                            value: position?.inMilliseconds?.toDouble() ?? 0,
                            onChanged: (double value) =>
                                player.seek((value / 1000).roundToDouble()),
                            min: 0.0,
                            max: song.duration.toDouble() + 1000,
                          ),

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
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              // "3:42",
                              durationText,
                              // '${(duration.inSeconds / 60) .toStringAsFixed(0)} : ${(duration.inSeconds % 60)}',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold),
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
                        icon: isFav == 0
                            ? Icon(
                                Icons.favorite_border,
                                color: Colors.blueGrey,
                                size: 15.0,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.blueGrey,
                                size: 15.0,
                              ),
                        onPressed: () {
                          setFav(song);
                        },
                      ),
                      IconButton(
                        splashColor: Colors.blueGrey[200],
                        highlightColor: Colors.transparent,
                        icon: new Icon(
                          Icons.skip_previous,
                          color: Colors.blueGrey,
                          size: 32.0,
                        ),
                        onPressed: prev,
                      ),
                      // GestureDetector(
                      //   onTap:
                      //       isPlaying ? () => pause() : () => play(widget.song),
                      //   // songData.play(url),
                      //   child: Card(
                      //     color: backgroundColor,
                      //     elevation: 12,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(16)),
                      //     child: Container(
                      //       height: 84,
                      //       width: 48,
                      //       child: Center(
                      //         child: Icon(
                      //           isPlaying ? Icons.pause : Icons.play_arrow,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: FloatingActionButton(
                          backgroundColor: _animateColor.value,
                          child: new AnimatedIcon(
                              icon: AnimatedIcons.pause_play,
                              progress: _animateIcon),
                          onPressed: playPause,
                        ),
                      ),
                      IconButton(
                        splashColor: Colors.blueGrey[200].withOpacity(0.5),
                        highlightColor: Colors.transparent,
                        icon: new Icon(
                          Icons.skip_next,
                          color: Colors.blueGrey,
                          size: 32.0,
                        ),
                        onPressed: next,
                      ),
                      IconButton(
                          icon: (repeatOn == 1)
                              ? Icon(
                                  Icons.repeat,
                                  color: Colors.blueGrey,
                                  size: 15.0,
                                )
                              : Icon(
                                  Icons.repeat,
                                  color: Colors.blueGrey.withOpacity(0.5),
                                  size: 15.0,
                                ),
                          onPressed: () {
                            repeat1();
                          }),
                    ],
                  ),
                ),
                Positioned(
                    child: Container(
                  width: 60,
                  color: Colors.white,
                  child: FlatButton(
                    onPressed: _showBottomSheet,
                    highlightColor: Colors.blueGrey[200].withOpacity(0.1),
                    child: Text(
                      "UP NEXT",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold),
                    ),
                    splashColor: Colors.blueGrey[200].withOpacity(0.1),
                  ),
                ))
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          topRight: Radius.circular(6.0))),
                  color: Color(0xFFFAFAFA)),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Scrollbar(
                child: new ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: widget.songs.length,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06,
                      right: MediaQuery.of(context).size.width * 0.06,
                      top: 10.0),
                  itemBuilder: (context, i) => new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: new CircleAvatar(
                          child: getImage(widget.songs[i]) != null
                              ? new Image.file(
                                  getImage(widget.songs[i]),
                                  height: 120.0,
                                  fit: BoxFit.cover,
                                )
                              : new Text(
                                  widget.songs[i].title[0].toUpperCase()),
                        ),
                        title: new Text(widget.songs[i].title,
                            maxLines: 1, style: new TextStyle(fontSize: 16.0)),
                        subtitle: Row(
                          children: <Widget>[
                            new Text(
                              widget.songs[i].artist,
                              maxLines: 1,
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Text("-"),
                            ),
                            Text(
                                new Duration(
                                        milliseconds: widget.songs[i].duration)
                                    .toString()
                                    .split('.')
                                    .first
                                    .substring(3, 7),
                                style: new TextStyle(
                                    fontSize: 11.0, color: Colors.black54))
                          ],
                        ),
                        trailing: widget.songs[i].id ==
                                MyQueue.songs[MyQueue.index].id
                            ? new Icon(Icons.play_circle_filled,
                                color: Colors.blueGrey[700])
                            : null,
                        onTap: () {
                          setState(() {
                            MyQueue.index = i;
                            player.stop();
                            updatePage(MyQueue.index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  Future<void> setFav(song) async {
    int i = await widget.db.favSong(song);
    setState(() {
      if (isFav == 1)
        isFav = 0;
      else
        isFav = 1;
    });
  }

  Future<void> repeat1() async {
    setState(() {
      if (repeatOn == 0) {
        repeatOn = 1;
        //widget.repeat.write(1);
      } else {
        repeatOn = 0;
        // widget.repeat.write(0);
      }
    });
  }
}
