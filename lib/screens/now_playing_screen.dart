import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_player/data/song_data.dart';
import 'package:test_player/main_page.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:provider/provider.dart';
import '../provider/songs_provider.dart';
import 'package:flute_music_player/flute_music_player.dart';

enum PlayerState { stopped, playing, paused }

class NowPlayingScreen extends StatefulWidget {
  static const routeName = '/now-playing';

  final Song song;
  final SongData songData;
  final bool nowPlayTap;

  const NowPlayingScreen({Key key, this.song, this.songData, this.nowPlayTap})
      : super(key: key);
  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  List<int> soundBars = [];
  double barWidth = 5.0;
  double soundPosition = 0.0;
  double nextSoundPosition = 140.0;

  Random r = math.Random();

  @override
  void initState() {
    super.initState();
    initPlayer();
    for (int i = 0; i < 72; i++) {
      soundBars.add(r.nextInt((52)));
    }
  }

  final slider = SleekCircularSlider(
    appearance: CircularSliderAppearance(
      startAngle: 180,
      angleRange: 180,
      counterClockwise: true,
      size: 330,
      customWidths: CustomSliderWidths(
          trackWidth: 3, handlerSize: 10, progressBarWidth: 10, shadowWidth: 5),
      // customColors: CustomSliderColors(),
    ),
    min: 0,
    max: 100,
    initialValue: 50,
    onChange: (double value) {
      // callback providing a value while its being changed (with a pan gesture)
    },

    // innerWidget: (double value) {
    //   // use your custom widget inside the slider (gets a slider value from the callback)
    // },
  );

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

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future next(SongData s) async {
    stop();
    setState(() {
      play(s.nextSong);
    });
  }

  Future prev(SongData s) async {
    stop();
    play(s.prevSong);
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
    Songs songData = Provider.of<Songs>(context);

    int i = 0;

    // backgroundColor: Colors.yellow,
    return Stack(
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
              color: Colors.blue,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    "https://instagram.fdel1-1.fna.fbcdn.net/v/t51.2885-19/s150x150/66426324_2390068234647773_650296368312614912_n.jpg?_nc_ht=instagram.fdel1-1.fna.fbcdn.net&_nc_ohc=drKdY2Es2esAX8whKU1&oh=789b9193573d389aff31582e1e88a20f&oe=5EBFF35B"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.yellow,
              ),
            ),
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
                  height: 52,
                  child: Row(
                    children: soundBars.map((h) {
                      Color color = i >= soundPosition / barWidth &&
                              i <= nextSoundPosition / barWidth
                          ? Colors.yellow
                          : Colors.grey;
                      i++;
                      return Container(
                        margin: EdgeInsets.only(right: 1),
                        color: color,
                        height: h.toDouble(),
                        width: 4,
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "1:35",
                      style:
                          GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "3:42",
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
                onPressed: () {
                  soundBars.clear();
                  for (int i = 0; i < 72; i++) {
                    soundBars.add(r.nextInt((52)));
                  }
                  setState(() {});
                },
              ),
              GestureDetector(
                  onTap: () => prev(widget.songData),
                  child: Icon(Icons.skip_previous)),
              GestureDetector(
                onTap: isPlaying ? () => pause() : play(widget.song),
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
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final rect = Rect.fromLTRB(50, 100, 150, 200);
    final startAngle = -math.pi;
    final sweepAngle = -math.pi;
    final useCenter = false;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
