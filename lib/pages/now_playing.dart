import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
// import 'package:musicplayer/pages/artistcard.dart';
// import 'package:musicplayer/util/artistInfo.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_visualizers/Visualizers/LineVisualizer.dart';
// import 'package:flutter_visualizers/visualizer.dart';
// import 'package:flutter_visualizers/Visualizers/LineVisualizer.dart';
// import 'package:flutter_visualizers/visualizer.dart';
// import 'package:pimp_my_button/pimp_my_button.dart';
// import 'package:musicplayer/database/database_client.dart';
// import 'package:musicplayer/util/lastplay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_player/database/database_client.dart';
// import 'package:test_player/pages/artistcard.dart';
import 'package:test_player/util/artistInfo.dart';
import 'package:test_player/util/lastplay.dart';
// import 'package:flutter_visualizers/flutter_visualizers.dart';
import '../util/methodcalls.dart';

class NowPlaying extends StatefulWidget {
  final int mode;
  final List<Song> songs;
  int index;
  final DatabaseClient db;

  NowPlaying(this.db, this.songs, this.index, this.mode);

  @override
  State<StatefulWidget> createState() {
    return new _StateNowPlaying();
  }
}

double widthX;
double sHeightX;

class _StateNowPlaying extends State<NowPlaying>
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
  // int playerID;

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
    // initPlatformState();
  }

  // int playerID;

  // Future<void> initPlatformState() async {
  //   // MethodCalls.playSong();
  //   int sessionId;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     sessionId = await MethodCalls.getSessionId();
  //   } on Exception {
  //     sessionId = null;
  //   }

  //   setState(() {
  //     playerID = sessionId;
  //   });
  // }

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
            // end: Theme.of(context).bottomAppBarColor,
            // // .withOpacity(0.7),
            // begin: Theme.of(context).scaffoldBackgroundColor,
            // // .withOpacity(0.9),
            )
        .animate(CurvedAnimation(
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

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      key: scaffoldState,
      body: song != null
          ? portrait(_theme)
          : Center(
              child: CircularProgressIndicator(),
            ),
      backgroundColor: Theme.of(context).accentColor,
// Theme.of(context).scaffoldBackgroundColor,
      // Colors.white,
      //  Theme.of(context).bottomAppBarColor,
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
                      left: MediaQuery.of(context).size.width * 0.02,
                      right: MediaQuery.of(context).size.width * 0.02,
                      top: 10.0),
                  itemBuilder: (context, i) => new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: new CircleAvatar(
                          backgroundImage: getImage(widget.songs[i]) != null
                              ? FileImage(
                                  getImage(widget.songs[i]),
                                )
                              // child:  new Image.file(

                              //         height: 120.0,
                              //         fit: BoxFit.cover,
                              //       )
                              : null,
                          child: getImage(widget.songs[i]) == null
                              ? Text(widget.songs[i].title[0].toUpperCase())
                              : null,
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
                                color: Colors.blue[700])
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

  Widget portrait(_theme) {
    double width = MediaQuery.of(context).size.width;
    widthX = width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    sHeightX = statusBarHeight;
    // final double cutRadius = 8.0;
    return Stack(
      children: <Widget>[
        // Positioned(
        //     child: Visualizer(
        //   builder: (BuildContext context, List<int> wave) {
        //     return new CustomPaint(
        //       painter: LineVisualizer(
        //         waveData: wave,
        //         height: MediaQuery.of(context).size.height,
        //         width: MediaQuery.of(context).size.width,
        //         color: Colors.blueAccent,
        //       ),
        //       child: new Container(),
        //     );
        //   },
        //   id: playerID,
        // )),
        Positioned(
          top: 35,
          left: 5,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        // Container(
        //     height: MediaQuery.of(context).size.width,
        //     color: Colors.white,
        //     child: getImage(song) != null
        //         ? Image.file(
        //             getImage(song),
        //             fit: BoxFit.fitHeight,
        //           )
        //         : Image.asset(
        //             "images/music.jpg",
        //             fit: BoxFit.fitWidth,
        //             width: MediaQuery.of(context).size.width,
        //           )),
        // Positioned(
        //   top: width,
        //   child: Container(
        //     color: Colors.white,
        //     height: MediaQuery.of(context).size.height - width,
        //     width: width,
        //   ),
        // ),
        // BackdropFilter(
        //   filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        //   child: Container(
        //     height: width,
        //     decoration:
        //         new BoxDecoration(color: Colors.grey[900].withOpacity(0.5)),
        //   ),
        // ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: width * 0.06 * 2),
            child: Container(
              width: width - 2 * width * 0.06,
              height: width - width * 0.06,
              child: AspectRatio(
                aspectRatio: 15 / 15,
                child: getImage(song) != null
                    // tag: song.id,
                    ? GestureDetector(
                        onDoubleTap: () {
                          setFav(song);
                        },
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: song.id,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                // borderRadius:
                                //     BorderRadius.circular(cutRadius),
                                image: DecorationImage(
                                    image: FileImage(getImage(song)),
                                    fit: BoxFit.cover)),
                            child: Stack(
                              children: <Widget>[
                                _showArtistImage
                                    ? GestureDetector(
                                        onDoubleTap: () {
                                          setFav(song);
                                        },
                                        child: Container(
                                          width: width - 2 * width * 0.06,
                                          height: width - width * 0.06,
                                          // child: GetArtistDetail(
                                          //   artist: song.artist,
                                          //   artistSong: song,
                                          // ),
                                        ),
                                      )
                                    : Container(),
                                Positioned(
                                  bottom: 40,
                                  right: 35,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    // child: PimpedButton(
                                    //   particle: Rectangle2DemoParticle(),
                                    //   pimpedWidgetBuilder: (context, controller) {
                                    //     return IconButton(
                                    //       icon: Icon(Icons.favorite_border),
                                    //       color: Colors.indigo,
                                    //       onPressed: () {
                                    //         controller.forward(from: 0.0);
                                    //         setFav(song);
                                    //       },
                                    //     );
                                    //   },
                                    // ),
                                    child: IconButton(
                                        icon: isFav == 0
                                            ? new Icon(
                                                Icons.favorite_border,
                                                color: Colors.red,
                                                size: 50.0,
                                              )
                                            : new Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 50.0,
                                              ),
                                        onPressed: () {
                                          setFav(song);
                                        }),
                                    // decoration: ShapeDecoration(
                                    //     color: Colors.red,
                                    //     shape: BeveledRectangleBorder(
                                    //         borderRadius: BorderRadius.only(
                                    //             topLeft: Radius.circular(
                                    //                 width * 0.15)))),
                                    // height: width * 0.15 * 2,
                                    // width: width * 0.15 * 2,
                                  ),
                                ),
                                // Positioned(
                                //   bottom: 0.0,
                                //   right: 0.0,
                                //   child: Padding(
                                //     padding:
                                //         EdgeInsets.only(right: 4.0, bottom: 6.0),
                                //     child: Text(
                                //       durationText,
                                //       style: TextStyle(
                                //         color: Colors.black,
                                //         fontWeight: FontWeight.w600,
                                //         fontSize: 18.0,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      )
                    // )
                    // )
                    : GestureDetector(
                        onDoubleTap: () {
                          setFav(song);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Theme.of(context).accentColor,
                            // borderRadius:
                            //     BorderRadius.circular(cutRadius),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Icon(
                                Icons.music_note,
                                size: 150,
                                color: Colors.white,
                              ),
                              _showArtistImage
                                  ? GestureDetector(
                                      onDoubleTap: () {
                                        setFav(song);
                                      },
                                      child: Container(
                                        width: width - 2 * width * 0.06,
                                        height: width - width * 0.06,
                                        // child: GetArtistDetail(
                                        //   artist: song.artist,
                                        //   artistSong: song,
                                        // ),
                                      ),
                                    )
                                  : Container(),
                              Positioned(
                                bottom: 40,
                                right: 35,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: IconButton(
                                      icon: isFav == 0
                                          ? new Icon(
                                              Icons.favorite_border,
                                              color: Colors.red,
                                              size: 50.0,
                                            )
                                          : new Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 50.0,
                                            ),
                                      onPressed: () {
                                        setFav(song);
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                // Material(
                //     color: Colors.transparent,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(
                //         cutRadius,
                //       ),
                //     ),
                //     clipBehavior: Clip.antiAlias,
                //     child: Stack(
                //       fit: StackFit.expand,
                //       children: <Widget>[
                // Icon(
                //   Icons.music_note,
                //   size: 150,
                // ),
                //         // Image.asset(
                //         //   "images/back.jpg",
                //         //   fit: BoxFit.cover,
                //         // ),
                //         // Positioned(
                //         //   bottom: -width * 0.15,
                //         //   right: -width * 0.15,
                //         //   child: Container(
                //         //     decoration: ShapeDecoration(
                //         //         color: Colors.white,
                //         //         shape: BeveledRectangleBorder(
                //         //             borderRadius: BorderRadius.only(
                //         //                 topLeft: Radius.circular(
                //         //                     width * 0.15)))),
                //         //     height: width * 0.15 * 2,
                //         //     width: width * 0.15 * 2,
                //         //   ),
                //         // ),
                //         // Positioned(
                //         //   bottom: 0.0,
                //         //   right: 0.0,
                //         //   child: Padding(
                //         //     padding:
                //         //         EdgeInsets.only(right: 4.0, bottom: 6.0),
                //         //     child: Text(
                //         //       durationText,
                //         //       style: TextStyle(
                //         //         color: Colors.black,
                //         //         fontSize: 16.0,
                //         //       ),
                //         //     ),
                //         //   ),
                //         // ),
                //         Positioned(
                //           bottom: 40,
                //           right: 35,
                //           child: Container(
                //             height: 50,
                //             width: 50,
                //             // child: PimpedButton(
                //             //   particle: Rectangle2DemoParticle(),
                //             //   pimpedWidgetBuilder: (context, controller) {
                //             //     return IconButton(
                //             //       icon: Icon(Icons.favorite_border),
                //             //       color: Colors.indigo,
                //             //       onPressed: () {
                //             //         controller.forward(from: 0.0);
                //             //         setFav(song);
                //             //       },
                //             //     );
                //             //   },
                //             // ),
                //             child: IconButton(
                //               icon: isFav == 0
                //                   ? new Icon(
                //                       Icons.favorite_border,
                //                       color: Colors.red,
                //                       size: 50.0,
                //                     )
                //                   : new Icon(
                //                       Icons.favorite,
                //                       color: Colors.red,
                //                       size: 50.0,
                //                     ),
                //               onPressed: () {
                //                 setFav(song);
                //               },
                //             ),
                //             // decoration: ShapeDecoration(
                //             //     color: Colors.red,
                //             //     shape: BeveledRectangleBorder(
                //             //         borderRadius: BorderRadius.only(
                //             //             topLeft: Radius.circular(
                //             //                 width * 0.15)))),
                //             // height: width * 0.15 * 2,
                //             // width: width * 0.15 * 2,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: width * 1.11),
            child: Container(
              height: MediaQuery.of(context).size.height - width * 1.11,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 5),
                              child: new Text(
                                '${song.title}\n',
                                style: new TextStyle(
                                    color: Colors.white,
                                    // Colors.black.withOpacity(0.85),
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            new Text(
                              "${song.artist}\n",
                              style: new TextStyle(
                                  color: Colors.white,
                                  // Colors.black.withOpacity(0.7),
                                  fontSize: 14.0,
                                  letterSpacing: 1.8,
                                  height: 1.5),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          positionText,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              // Colors.black,
                              //  Color(0xaa373737),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                        ),
                        Expanded(
                          child: Slider(
                            min: 0.0,
                            activeColor: _theme.darkMode
                                ? Colors.white
                                : Theme.of(context).bottomAppBarColor,
                            // Colors.yellow,
                            // Colors.blueGrey.shade400.withOpacity(0.5),
                            // Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                            // Colors.white,
                            inactiveColor: Colors.white.withOpacity(0.5),
                            // Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                            // Colors.blueGrey.shade300.withOpacity(0.3),
                            value: position?.inMilliseconds?.toDouble() ?? 0.0,
                            onChanged: (double value) =>
                                player.seek((value / 1000).roundToDouble()),
                            max: song.duration.toDouble() + 1000,
                          ),
                        ),
                        Text(
                          durationText,
                          style: TextStyle(
                              fontSize: 13.0,
                              // color: Color(0xaa373737),
                              color: Colors.white,
                              //  Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            NavButtons(
                              song: song,
                              isFav: isFav,
                              ontap: () {
                                setFav(song);
                              },
                              childd: isFav == 0
                                  ? new Icon(
                                      Icons.favorite_border,
                                      color: Colors.white70,
                                      // blue,
                                      size: 28.0,
                                    )
                                  : new Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      // blue,
                                      size: 28.0,
                                    ),
                            ),
                            // new IconButton(
                            //   icon: isFav == 0
                            //       ? new Icon(
                            //           Icons.favorite_border,
                            //           color: Colors.blue,
                            //           size: 15.0,
                            //         )
                            //       : new Icon(
                            //           Icons.favorite,
                            //           color: Colors.blue,
                            //           size: 15.0,
                            //         ),
                            //   onPressed:
                            // () {
                            //     setFav(song);
                            //   },
                            // ),
                            // Padding(
                            //     padding:
                            //         EdgeInsets.symmetric(horizontal: 15.0)),
                            NavButtons(
                              song: song,
                              isFav: null,
                              ontap: prev,
                              childd: Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                                //  Colors.blue,
                                size: 32.0,
                              ),
                            ),

                            // new IconButton(
                            //   splashColor: Colors.blue[200],
                            //   highlightColor: Colors.transparent,
                            //   icon: new
                            // Icon(
                            //     Icons.skip_previous,
                            //     color: Colors.blue,
                            //     size: 32.0,
                            //   ),
                            //   onPressed: prev,
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            //   child: FloatingActionButton(
                            //     backgroundColor: _animateColor.value,
                            //     child: new AnimatedIcon(
                            //         icon: AnimatedIcons.pause_play,
                            //         progress: _animateIcon),
                            //     onPressed: playPause,
                            //   ),
                            // ),
                            PlayPauseButton(
                              animateColor: _animateColor,
                              animateIcon: _animateIcon,
                              playPause: () {
                                playPause();
                              },
                            ),
                            // new IconButton(
                            //   splashColor: Colors.blue[200].withOpacity(0.5),
                            //   highlightColor: Colors.transparent,
                            //   icon: new Icon(
                            //     Icons.skip_next,
                            //     color: Colors.blue,
                            //     size: 32.0,
                            //   ),
                            //   onPressed: next,
                            // ),

                            NavButtons(
                              song: song,
                              isFav: null,
                              ontap: next,
                              childd: Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                // Colors.blue,
                                size: 32.0,
                              ),
                            ),
                            // Padding(
                            //     padding:
                            //         EdgeInsets.symmetric(horizontal: 15.0)),
                            NavButtons(
                              song: song,
                              isFav: null,
                              repeatOn: repeatOn,
                              ontap: () => repeat1(),
                              childd: (repeatOn == 1)
                                  ? Icon(
                                      Icons.repeat,
                                      color: Colors.white,
                                      // Colors.blue,
                                      size: 28.0,
                                    )
                                  : Icon(
                                      Icons.repeat,
                                      color: Colors.white38,
                                      // blue.withOpacity(0.5),
                                      size: 28.0,
                                    ),
                            ),
                            // new IconButton(
                            //     icon: (repeatOn == 1)
                            //         ? Icon(
                            //             Icons.repeat,
                            //             color: Colors.blue,
                            //             size: 15.0,
                            //           )
                            //         : Icon(
                            //             Icons.repeat,
                            //             color: Colors.blue.withOpacity(0.5),
                            //             size: 15.0,
                            //           ),
                            //     onPressed: () {
                            //       repeat1();
                            //     }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    color: Colors.white,
                    child: FlatButton(
                      onPressed: _showBottomSheet,
                      highlightColor: Colors.blue[200].withOpacity(0.1),
                      child: Text(
                        "UP NEXT",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold),
                      ),
                      splashColor: Colors.blue[200].withOpacity(0.1),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
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

  Future<void> setFav(song) async {
    int i = await widget.db.favSong(song);
    setState(() {
      if (isFav == 1)
        isFav = 0;
      else
        isFav = 1;
    });
  }
}

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key key,
    @required Animation<ui.Color> animateColor,
    @required Animation<double> animateIcon,
    @required this.playPause,
  })  : _animateColor = animateColor,
        _animateIcon = animateIcon,
        super(key: key);

  final Animation<ui.Color> _animateColor;
  final Animation<double> _animateIcon;
  final Function playPause;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: playPause,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                offset: Offset(5, 10),
                spreadRadius: 3,
                blurRadius: 10),
            BoxShadow(
                color: Theme.of(context).scaffoldBackgroundColor,
                // Colors.white,
                offset: Offset(-3, -4),
                spreadRadius: -2,
                blurRadius: 20)
          ],
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    // Theme.of(context).accentColor,
                    // Theme.of(context).scaffoldBackgroundColor,
                    // Theme.of(context).bottomAppBarColor,
                    color: Theme.of(context).bottomAppBarColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.5),
                          offset: Offset(5, 10),
                          spreadRadius: 3,
                          blurRadius: 10),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -4),
                          spreadRadius: -2,
                          blurRadius: 20)
                    ]),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    // _animateColor.value,
                    // color: Colors.pink,
                    shape: BoxShape.circle),
                child: Center(
                  child: AnimatedIcon(
                    icon: AnimatedIcons.pause_play,
                    progress: _animateIcon,
                    color: Colors.white,
                    // !_animateIcon.isCompleted
                    //     ? Colors.white
                    //     : Theme.of(context).accentColor,
                    size: 55,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavButtons extends StatelessWidget {
  const NavButtons({
    Key key,
    @required this.song,
    @required this.isFav,
    @required this.ontap,
    @required this.childd,
    this.repeatOn,
  }) : super(key: key);

  final Song song;
  final int isFav;
  final Function ontap;
  final Widget childd;
  final int repeatOn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                offset: Offset(5, 10),
                spreadRadius: 3,
                blurRadius: 10),
            BoxShadow(
                // color: Theme.of(context).bottomAppBarColor,
                color: Theme.of(context).scaffoldBackgroundColor,
                // Colors.white,
                offset: Offset(-3, -4),
                spreadRadius: -2,
                blurRadius: 20)
          ],
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Theme.of(context).bottomAppBarColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.5),
                          offset: Offset(5, 10),
                          spreadRadius: 1.5,
                          blurRadius: 5),
                      BoxShadow(
                          color:
                              //  Theme.of(context).bottomAppBarColor,
                              Colors.white,
                          offset: Offset(-3, -4),
                          spreadRadius: -2,
                          blurRadius: 20)
                    ]),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(8.4),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: childd,
                  //      Icon(
                  //   Icons.,
                  //   size: 30,
                  //   color: Colors.red,
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Theme.of(context).accentColor,
// Theme.of(context).scaffoldBackgroundColor,
// Theme.of(context).bottomAppBarColor,
// _theme.darkMode
//                           ? Theme.of(context).textTheme.headline.color
//                           : Color(0xff6e00db),
