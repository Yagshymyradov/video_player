import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: ListView(
        children: const[
          VideoPlayerView(
            url: 'assets/room.mp4',
            dataSourceType: DataSourceType.asset,
          ),
          VideoPlayerView(
            url: 'https://www.youtube.com/watch?v=H5v3kku4y6Q',
            dataSourceType: DataSourceType.network,
          ),
          SizedBox(height: 24,),
          SelectVideo()
        ],
      ),
    );
  }
}
