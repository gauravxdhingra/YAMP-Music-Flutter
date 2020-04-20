// import 'package:flutter/services.dart';

// class MethodCalls {
//   static const MethodChannel _channel = const MethodChannel('calls');

//   static Future<int> getSessionId() async {
//     int session;
//     try {
//       final int result = await _channel.invokeMethod('getSessionID');
//       session = result;
//     } on PlatformException catch (e) {
//       print(e);
//       session = null;
//     }
//     return session;
//   }

//   // static playSong() async {
//   //   _channel.invokeMethod('playSong');
//   // }
// }
