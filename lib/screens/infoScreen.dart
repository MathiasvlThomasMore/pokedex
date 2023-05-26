// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pokedex/config.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InfoScreen extends StatefulWidget {
  InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final videoURL = "https://www.youtube.com/watch?v=lpJJBfJYAnY";

  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);
    _controller = YoutubePlayerController(
        initialVideoId: videoID!, flags: YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(child: Text('About')),
            backgroundColor: Colors.red),
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
            child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            const Center(
              child: Text("Pokédex",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  )),
            ),
            const Center(
                child: Text("Version ${MyConfig.versionNumber}",
                    style: TextStyle(color: Colors.white))),
            const Center(
              child: Text("Made by Mathias Van Langendonck",
                  style: TextStyle(color: Colors.white)),
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Text(MyConfig.aboutText,
                    style: TextStyle(color: Colors.white)))
          ],
        )));
  }
}
