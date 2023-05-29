import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_app/pages/home_page.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({Key? key, required this.url, required this.dataSourceType}) : super(key: key);
  final String url;
  final DataSourceType dataSourceType;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch(widget.dataSourceType) {
      case DataSourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.network(widget.url);
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri:
        _videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }
    _videoPlayerController.initialize().then(
            (value) => setState(
                () => _chewieController = ChewieController(
                    videoPlayerController: _videoPlayerController,
                    aspectRatio: _videoPlayerController.value.aspectRatio
                )
            )
    );
  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.dataSourceType.name.toUpperCase(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        _videoPlayerController.value.isInitialized
            ?AspectRatio(
          aspectRatio: _videoPlayerController.value.aspectRatio,
          child: Chewie(controller: _chewieController,),
        )
            : const SizedBox.shrink()
      ],
    );
  }
}

class SelectVideo extends StatefulWidget {
  const SelectVideo({Key? key}) : super(key: key);

  @override
  State<SelectVideo> createState() => _SelectVideoState();
}

class _SelectVideoState extends State<SelectVideo> {
  File? _file;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(onPressed: () async{
          final file =
              await ImagePicker().pickVideo(source: ImageSource.gallery);
          if(file != null) {
            setState(() => _file = File(file.path));
          }
        },
            child: Text('Select Video')),
        if(_file != null)
          VideoPlayerView(
              url: _file!.path,
              dataSourceType: DataSourceType.file,
          )
      ],
    );
  }
}
