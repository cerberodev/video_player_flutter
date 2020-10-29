import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  final String lat = '26.157539';
  final String lng = '-80.214855';

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();

    //_controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: DrawerHeader(
            child: Column(
          children: [
            FlutterLogo(
              size: 50,
            ),
            Divider(),
            RaisedButton(
              onPressed: () async {
                String telephoneNumber = "tel:915975385";
                if (await canLaunch(telephoneNumber)) {
                  await launch(telephoneNumber);
                } else {
                  throw 'Could not launch $telephoneNumber';
                }
              },
              child: Text('Telephone'),
            ),
            FlatButton(onPressed: () {}, child: Text('Email')),
            OutlineButton.icon(
              onPressed: () async {
                final googleMapsUrl = 'comgooglemaps://?center=$lat,$lng';
                final appleMapsUrl = 'https://maps.apple.com/?q=$lat,$lng';
                if (await canLaunch(googleMapsUrl)) {
                  await launch(googleMapsUrl);
                }
                if (await canLaunch(appleMapsUrl)) {
                  await launch(appleMapsUrl, forceSafariVC: false);
                } else {
                  throw "Not connect with URL";
                }
              },
              icon: Icon(Icons.map),
              label: Text('Maps'),
            ),
            IconButton(
                icon: Icon(Icons.laptop_chromebook),
                onPressed: () {
                  print("alert");
                  _launchURL();
                })
          ],
        )),
      ),
      appBar: AppBar(title: Text('Video Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return Center(child: CupertinoActivityIndicator());
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.laptop_chromebook),
              onPressed: () async {
                if (await canLaunch('https://flutter.dev')) {
                  final nativeAppLaunchedSucceeded = await launch(
                    'https://flutter.dev',
                    universalLinksOnly: true,
                    forceSafariVC: false,
                  );
                  if (!nativeAppLaunchedSucceeded) {
                    await launch(
                      'https://flutter.dev',
                      universalLinksOnly: false,
                      forceSafariVC: false,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Icon(
              _controller.value.isPlaying
                  ? Icons.stop
                  : Icons.play_arrow_rounded,
            ),
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
