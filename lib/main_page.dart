import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './play_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

Color backgroundColor = Color(0xff7800ee);

class MusicPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = ScrollController();
  final _controller1 = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: backgroundColor,
        color: Colors.blue[50],
        // animationDuration: Duration(seconds: 3),
        index: 4,
        items: <Widget>[
          Icon(
            MdiIcons.musicNote,
          ),
          Icon(
            MdiIcons.heart,
          ),
          Icon(
            MdiIcons.playPause,
            // size: 36,
          ),
          Icon(
            MdiIcons.playlistMusic,
          ),
          Icon(
            MdiIcons.magnify,
          ),
        ],
        onTap: (index) {
          if (index == 2)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => PlayPage()));
        },
        height: 52,
        animationCurve: Curves.fastLinearToSlowEaseIn,
      ),
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 48,
            top: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 8,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(42),
                ),
                // image: DecorationImage(
                //     image: NetworkImage(
                //         "https://media0.giphy.com/media/DzVNG1mBlIPEQ/giphy.gif?cid=790b7611c56e7e124f919b235eb3057982e4cdaeee62b52e&rid=giphy.gif"),
                //     fit: BoxFit.cover),
              ),
            ),
          ),
//          6e00db
          // Positioned(
          //   right: 48,
          //   top: MediaQuery.of(context).size.height / 2.4,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (context) => PlayPage()));
          //     },
          //     child: Container(
          //       height: 84,
          //       width: 84,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         shape: BoxShape.circle,
          //       ),
          //       child: Center(
          //         child: Icon(
          //           Icons.play_arrow,
          //           color: backgroundColor,
          //           size: 48,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            // bottom: 0,
            top: MediaQuery.of(context).size.height / 6.5,
            right: 15,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.32,
              padding: EdgeInsets.only(left: 24, top: 24),
              decoration: BoxDecoration(
                  color: Color(0xff6e00db),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(42),
                    bottomRight: Radius.circular(42),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Recent Songs",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 8,
                    child: FadingEdgeScrollView.fromScrollView(
                      child: ListView(
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 16, left: 0),
                            width: MediaQuery.of(context).size.width / 1.2,
//                          decoration: BoxDecoration(color: Colors.yellow),
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 84,
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 32,
                                        backgroundColor: Colors.yellow,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Secrets",
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "Not a Hobby 2020",
                                            style: GoogleFonts.montserrat(
                                                color: Colors.grey.shade200),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 24,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "My Music",
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 0),
                    height: MediaQuery.of(context).size.height / 1.9,
                    width: MediaQuery.of(context).size.width / 1.8,
                    // decoration: BoxDecoration(color: Colors.yellow),
                    // child: Text('data'),
                    child: FadingEdgeScrollView.fromScrollView(
                      child: ListView.builder(
                        controller: _controller1,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                                // color: Colors.purple,
                                ),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 32,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Secrets",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Not a Hobby 2020",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.grey.shade200),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //     Positioned(
          //       left: 42,
          //       top: MediaQuery.of(context).size.height / 7,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Text(
          //             "Head Shaker",
          //             style: GoogleFonts.montserrat(
          //                 color: Colors.white,
          //                 fontSize: 24,
          //                 fontWeight: FontWeight.bold),
          //           ),
          //           Row(
          //             children: <Widget>[
          //               Icon(
          //                 Icons.cloud_queue,
          //                 color: Colors.orange,
          //               ),
          //               SizedBox(
          //                 width: 8,
          //               ),
          //               Text(
          //                 "247k Followers",
          //                 style: GoogleFonts.montserrat(
          //                   fontSize: 14,
          //                   color: Colors.white,
          //                 ),
          //               )
          //             ],
          //           )
          //         ],
          //       ),
          //     ),
        ],
      ),
    );
  }
}
