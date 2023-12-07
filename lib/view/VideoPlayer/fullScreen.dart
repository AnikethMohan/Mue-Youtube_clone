import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mue/const/styles.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideo extends StatefulWidget {
  const FullScreenVideo(
      {super.key,
      required this.videoUrl,
      required this.title,
      required this.currentDuration});
  final videoUrl;
  final title;
  final Duration? currentDuration;

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late VideoPlayerController _controller;
  Duration? currenpos;
  bool isButtonEnabled = false;
  @override
  void initState() {
    // TODO: implement initState
    _controller = VideoPlayerController.networkUrl(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        setState(() {
          _controller.play();
        });
      });
    isButtonEnabled = true;

    Timer(Duration(seconds: 5), () {
      setState(() {
        isButtonEnabled = false;
      });
    });

    _controller.addListener(() async {
      currenpos = await _controller.position;
    });

    super.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblack,
      body: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: GestureDetector(
          onTap: () {
            print('pressed');
          },
          child: VideoPlayer(
            _controller,
          ),
        ),
      ),
    );
  }
}
