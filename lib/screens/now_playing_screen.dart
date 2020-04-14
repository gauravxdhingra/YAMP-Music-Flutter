import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_player/main_page.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class NowPlayingScreen extends StatefulWidget {
  static const routeName='/now-playing';
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

  @override
  Widget build(BuildContext context) {
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
                        "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947__340.jpg"),
                    fit: BoxFit.cover)),
            child: Center(
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.yellow,
              ),
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          top: 100,
          child: Container(
            height: 300,
            color: Colors.grey.shade50.withOpacity(0.2),
            child: CustomPaint(
              size: Size(300, 300),
              painter: ArcPainter(),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 410,
          child: Container(
            height: 180,
            child: Column(
              children: <Widget>[
                Icon(Icons.music_note),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Sam Fischer",
                  style: GoogleFonts.montserrat(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "This City",
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
                          ? backgroundColor
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
              Icon(Icons.skip_previous),
              Card(
                  color: backgroundColor,
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    height: 84,
                    width: 48,
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  )),
              Icon(Icons.skip_next),
              Icon(Icons.shuffle),
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
