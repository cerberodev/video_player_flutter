import 'package:flutter/material.dart';
import 'package:video_player_flutter/ui/screen/video_player_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: VideoPlayerScreen(),
    );
  }
}
