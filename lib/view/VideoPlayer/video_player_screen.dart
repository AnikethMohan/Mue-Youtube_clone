// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mue/const/styles.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.channelData,
    required this.description,
    required this.duration,
    this.views,
  });
  final videoUrl;
  final title;
  final Channel channelData;
  final views;
  final description;
  final Duration duration;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  String views = '';
  String likes = '';
  String dislikes = '';
  Duration? currenpos;
  bool isButtonEnabled = false;
  bool isFullScreen = false;

  @override
  void initState() {
    Wakelock.enable();
    _controller = VideoPlayerController.networkUrl(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();

        setState(() {});
      });
    isButtonEnabled = true;

    Timer(const Duration(seconds: 5), () {
      setState(() {
        isButtonEnabled = false;
      });
    });

    _controller.addListener(() async {
      currenpos = await _controller.position;
    });

    super.initState();
  }

  formatNumber(dynamic myNumber) {
    // Convert number into a string if it was not a string previously
    String stringNumber = myNumber.toString();

    // Convert number into double to be formatted.
    // Default to zero if unable to do so
    double doubleNumber = double.tryParse(stringNumber) ?? 0;

    // Set number format to use
    NumberFormat numberFormat = NumberFormat.compact();

    return numberFormat.format(doubleNumber);
  }

  makeitInvisible() {
    setState(() {
      isButtonEnabled = true;
    });

    Timer(const Duration(seconds: 5), () {
      setState(() {
        isButtonEnabled = false;
      });
    });
  }

  fullscreen() {
    if (isFullScreen == false) {
      setState(() {
        isFullScreen = true;
      });
    } else {
      setState(() {
        isFullScreen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    views = formatNumber(widget.views);

    double width = MediaQuery.of(context).size.width;

    bool isExpanded = false;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kblack,
        body: Container(
          color: kblack,
          child: Wrap(
            children: [
              Stack(
                children: [
                  _controller.value.isInitialized
                      ? RotatedBox(
                          quarterTurns: isFullScreen ? 1 : 0,
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: GestureDetector(
                              onTap: () {
                                print('pressed');
                                makeitInvisible();
                              },
                              child: VideoPlayer(
                                _controller,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  _controller.value.isInitialized
                      ? FullScreenProgressBar()
                      : SizedBox(),
                  PlayBackControls(),
                  Visibility(
                    visible: isButtonEnabled,
                    child: Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            fullscreen();
                          },
                          icon: const Icon(
                            Icons.zoom_out_map_rounded,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              ),
              // VideoProgressIndicator(
              //   _controller,
              //   allowScrubbing: true,
              //   colors: VideoProgressColors(
              //     playedColor: kyellow,
              //   ),
              // )
              _controller.value.isInitialized
                  ? HalfScreenProgressBar()
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              Video_Description(width, isExpanded)
            ],
          ),
        ),
        // Center(
        //   child: _controller.value.isInitialized
        //       ? AspectRatio(
        //         aspectRatio: _controller.value.aspectRatio,
        //         child: VideoPlayer(
        //           _controller,
        //         ),
        //       )
        //       : Container(
        //           color: Colors.red,
        //         ),
        // ),
      ),
    );
  }

  ValueListenableBuilder<VideoPlayerValue> HalfScreenProgressBar() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Visibility(
            visible: !isFullScreen,
            child: ProgressBar(
              thumbColor: kyellow,
              thumbRadius: isButtonEnabled ? 10 : 0,
              baseBarColor: const Color(0xff35373D),
              progressBarColor: kyellow,
              progress: currenpos!,
              bufferedBarColor: const Color.fromARGB(255, 193, 194, 197),
              buffered: const Duration(seconds: 5),
              total: widget.duration,
              timeLabelTextStyle:
                  TextStyleMue(fontSize: 12, weight: FontWeight.bold),
              onSeek: (duration) {
                _controller.seekTo(duration);
              },
            ),
          ),
        );
      },
    );
  }

  Positioned PlayBackControls() {
    return Positioned.fill(
      child: Center(
        child: Visibility(
          visible: isButtonEnabled,
          child: RotatedBox(
            quarterTurns: isFullScreen ? 1 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      _controller.seekTo((await _controller.position)! -
                          const Duration(seconds: 10));
                    },
                    icon: Icon(
                      Icons.replay_10_rounded,
                      size: 40.sp,
                      color: Colors.white,
                    )),
                SizedBox(
                  width: 10.w,
                ),
                IconButton(
                  onPressed: () {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                    setState(() {});
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_outlined
                        : Icons.play_arrow_rounded,
                    size: 50.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                IconButton(
                    onPressed: () async {
                      _controller.seekTo((await _controller.position)! +
                          Duration(seconds: 10));
                    },
                    icon: Icon(
                      Icons.forward_10_rounded,
                      size: 40.sp,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Visibility FullScreenProgressBar() {
    return Visibility(
      visible: isFullScreen,
      child: Positioned.fill(
        child: Align(
          alignment: Alignment.centerLeft,
          child: RotatedBox(
            quarterTurns: 1,
            child: Visibility(
              visible: isButtonEnabled,
              child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ProgressBar(
                      thumbColor: kyellow,
                      thumbRadius: isButtonEnabled ? 10 : 0,
                      baseBarColor: Color(0xff35373D),
                      progressBarColor: kyellow,
                      progress: currenpos!,
                      bufferedBarColor:
                          const Color.fromARGB(255, 193, 194, 197),
                      buffered: const Duration(seconds: 5),
                      total: widget.duration,
                      timeLabelTextStyle:
                          TextStyleMue(fontSize: 12, weight: FontWeight.bold),
                      onSeek: (duration) {
                        _controller.seekTo(duration);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container Video_Description(double width, bool isExpanded) {
    return Container(
      width: width,
      child: ExpansionTile(
        iconColor: Colors.red,
        collapsedIconColor: Colors.white,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (value) {
          print('is expanded');

          setState(() {
            isExpanded = value;
          });
        },
        //video title
        title: Container(
          child: TextMue(
              text: widget.title.toString(),
              fontSize: 20.sp,
              maxlines: isExpanded == true ? 3 : 4,
              weight: FontWeight.w600,
              align: TextAlign.center),
        ),

        children: [
          SizedBox(
            height: 10,
          ),
          widget.channelData.logoUrl.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: 14.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ClipOval(
                          child: CircleAvatar(
                              child: Image.network(
                            widget.channelData.logoUrl,
                          )),
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        widget.channelData.title.isNotEmpty
                            ? TextMue(
                                text: widget.channelData.title,
                                fontSize: 15.sp,
                                weight: FontWeight.w500,
                                color: Color(0xffD5D6D6))
                            : SizedBox()
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.sp),
            child: Row(
              children: [
                views.isNotEmpty
                    ? Column(
                        children: [
                          TextMue(
                              text: views.toString(),
                              fontSize: 20.sp,
                              weight: FontWeight.bold,
                              color: Colors.white),
                          SizedBox(
                            height: 5.h,
                          ),
                          TextMue(
                              text: 'Views',
                              fontSize: 15.sp,
                              weight: FontWeight.w500,
                              color: Colors.white),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(
            color: Color(0xff36383F),
          ),
          Container(
            child: TextMue(
              text: widget.description,
              fontSize: 12.sp,
              weight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
