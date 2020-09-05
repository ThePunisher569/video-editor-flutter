import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  String videoFilePath;

  VideoPlayer(this.videoFilePath);
  @override
  _VideoPlayerState createState() => _VideoPlayerState(videoFilePath);
}

class _VideoPlayerState extends State<VideoPlayer> {
  String _videoFilePath;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;


  _VideoPlayerState(this._videoFilePath);

  @override
  void initState(){
    assert (new File(_videoFilePath)!=null);
    _videoPlayerController = VideoPlayerController.file(new File(_videoFilePath));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: true,
      looping: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.yellow,
        handleColor: Colors.black,
        bufferedColor: Colors.deepPurpleAccent,
        backgroundColor: Colors.grey
      )
    );
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
