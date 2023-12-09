import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mue/Controller/Image.dart';
import 'package:mue/view/Home/search_bar.dart';
import 'package:mue/const/styles.dart';
import 'package:mue/view/MusicPlayScreen/musicPlayer.dart';
import 'package:mue/view/VideoPlayer/video_player_screen.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResults extends StatefulWidget {
  SearchResults(
      {super.key, this.searchResult, this.yt, required this.searchquery});
  final VideoSearchList? searchResult;
  final YoutubeExplode? yt;
  final searchquery;

  @override
  State<SearchResults> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResults> {
  SearchController? controller;
  String? channelUrl;
  ImageProviders? imageProvider;
  List<String> urlList = [];

  var imageUrll;
  ImageProviders formatview = Get.put(ImageProviders());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: kblack,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            SearchBarResult(searchquery: widget.searchquery)
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.r),
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.searchResult!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // dynamic channelId = widget.searchResult![index].channelId;
              // void getimage() async {
              //   var imageurl;
              //   print('inside future');
              //   final Channel channaldata = await yts!.channels
              //       .get(widget.searchResult![index].channelId);

              //   imageurl = channaldata.bannerUrl;
              //   urlList.add(imageurl);
              // }

              // channelurl(index);

              // getimage();

              // controller.channelurl(widget.searchResult!.length,
              //     widget.searchResult, widget.searchResult!.length);

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onDoubleTap: () => null,
                        onTap: () async {
                          final videoid = widget.searchResult![index].id.value;
                          //manifest for video bit rate
                          var manifest = await widget.yt!.videos.streamsClient
                              .getManifest(videoid);

                          //title of the video
                          final title = widget.searchResult![index].title;
                          //for likes , views , dislikes
                          final views = await widget
                              .searchResult![index].engagement.viewCount;

                          //video url
                          var video_url = await manifest.muxed.bestQuality.url;
                          //channelId
                          final chanenlId =
                              await widget.searchResult![index].channelId;

                          final channelData =
                              await widget.yt!.channels.get(chanenlId);
                          final descrption = widget
                              .searchResult![index].description
                              .toString();
                          final duration = widget.searchResult![index].duration;

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoUrl: video_url,
                              title: title,
                              channelData: channelData,
                              views: views,
                              description: descrption,
                              duration: duration!,
                              searchresult: widget.searchResult!,
                              yt: widget.yt,
                              currentVideoindex: index,
                            ),
                          ));
                        },
                        child: Container(
                          height: 225.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FittedBox(
                              child: Image.network(
                                widget.searchResult![index].thumbnails
                                    .standardResUrl,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30.h,
                        right: 5.w,
                        child: Container(
                          height: 20.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                              color: Color(0xff212121),
                              borderRadius: BorderRadius.circular(6.r)),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                  text:
                                      '${widget.searchResult![index].duration!.toString()} '
                                          .split(':')[1],
                                  children: [
                                    TextSpan(text: ':'),
                                    TextSpan(
                                        text:
                                            ':${widget.searchResult![index].duration!.toString()}'
                                                .split(':')[3]
                                                .split('.')
                                                .first)
                                  ]),
                              style: TextStyleMue(
                                fontSize: 12.sp,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FutureBuilder(
                        future: widget.yt!.channels
                            .get(widget.searchResult![index].channelId),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ClipOval(
                                  child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.logoUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.w),
                        width: 250.w,
                        child: TextMue(
                            text: widget.searchResult![index].title,
                            fontSize: 12.sp,
                            weight: FontWeight.bold,
                            color: kblack,
                            maxlines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: PopupMenuButton<void Function()>(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: () async {
                                  final videoid =
                                      widget.searchResult![index].id.value;
                                  var manifest = await widget
                                      .yt!.videos.streamsClient
                                      .getManifest(videoid);
                                  var audioUrl =
                                      await manifest.audioOnly.first.url;

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MusicPlayer(
                                      audiourl: audioUrl,
                                      albumName:
                                          widget.searchResult![index].title,
                                      thumbnail: widget.searchResult![index]
                                          .thumbnails.standardResUrl,
                                      duration:
                                          widget.searchResult![index].duration,
                                      artist:
                                          widget.searchResult![index].author,
                                    ),
                                  ));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.music_note_outlined,
                                      color: kpink,
                                    ),
                                    Text('Play as a Song'),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 55.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextMue(
                            text:
                                '${widget.searchResult![index].author}    .   ',
                            fontSize: 10.sp,
                            weight: FontWeight.w500,
                            color: const Color(0xff737374)),
                        TextMue(
                            text:
                                '${formatview.formatNumber(widget.searchResult![index].engagement.viewCount)} views',
                            fontSize: 10.sp,
                            weight: FontWeight.w500,
                            color: const Color(0xff737374)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     InkWell(
                  //       onTap: () async {
                  //         final videoid =
                  //             widget.searchResult![index].id.value;
                  //         var manifest = await widget.yt!.videos.streamsClient
                  //             .getManifest(videoid);
                  //         var audioUrl = await manifest.audioOnly.first.url;

                  //         Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => MusicPlayer(
                  //             audiourl: audioUrl,
                  //             albumName: widget.searchResult![index].title,
                  //             thumbnail: widget.searchResult![index]
                  //                 .thumbnails.standardResUrl,
                  //             duration: widget.searchResult![index].duration,
                  //             artist: widget.searchResult![index].author,
                  //           ),
                  //         ));
                  //       },
                  //       child: CircleAvatar(
                  //           backgroundColor: kyellow,
                  //           child: Icon(
                  //             Icons.music_note_rounded,
                  //             color: kblack,
                  //           )),
                  //     ),
                  //     SizedBox(
                  //       height: 10,
                  //     ),
                  //     InkWell(
                  //       onTap: () async {
                  //         log('pressed video button ');
                  //         final videoid =
                  //             widget.searchResult![index].id.value;
                  //         //manifest for video bit rate
                  //         var manifest = await widget.yt!.videos.streamsClient
                  //             .getManifest(videoid);

                  //         //title of the video
                  //         final title = widget.searchResult![index].title;
                  //         //for likes , views , dislikes
                  //         final views = await widget
                  //             .searchResult![index].engagement.viewCount;

                  //         //video url
                  //         var video_url =
                  //             await manifest.muxed.withHighestBitrate().url;
                  //         //channelId
                  //         final chanenlId =
                  //             await widget.searchResult![index].channelId;

                  //         final channelData =
                  //             await widget.yt!.channels.get(chanenlId);
                  //         final descrption = widget
                  //             .searchResult![index].description
                  //             .toString();
                  //         final duration =
                  //             widget.searchResult![index].duration;

                  //         Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => VideoPlayerScreen(
                  //             videoUrl: video_url,
                  //             title: title,
                  //             channelData: channelData,
                  //             views: views,
                  //             description: descrption,
                  //             duration: duration!,
                  //           ),
                  //         ));
                  //       },
                  //       child: CircleAvatar(
                  //         backgroundColor: kpink,
                  //         child: Icon(
                  //           Icons.videocam,
                  //           color: kblack,
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  channelurl(
    int index,
  ) async {
    final channelId = widget.searchResult![index].channelId.toString();
    final Channel channaldata = await widget.yt!.channels.get(channelId);
    final imageurl = channaldata.logoUrl;
    print('$imageurl');
    setState(() {
      imageUrll = imageurl;
    });
  }
}

class SearchResultList extends StatefulWidget {
  const SearchResultList(
      {super.key,
      required this.searchResult,
      required this.yt,
      required this.currentvideoIndex});
  final VideoSearchList? searchResult;
  final YoutubeExplode? yt;
  final currentvideoIndex;

  @override
  State<SearchResultList> createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  @override
  Widget build(BuildContext context) {
    ImageProviders formatview = Get.put(ImageProviders());
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.searchResult!.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // dynamic channelId = widget.searchResult![index].channelId;
        // void getimage() async {
        //   var imageurl;
        //   print('inside future');
        //   final Channel channaldata = await yts!.channels
        //       .get(widget.searchResult![index].channelId);

        //   imageurl = channaldata.bannerUrl;
        //   urlList.add(imageurl);
        // }

        // channelurl(index);

        // getimage();

        // controller.channelurl(widget.searchResult!.length,
        //     widget.searchResult, widget.searchResult!.length);

        return index != widget.currentvideoIndex
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onDoubleTap: () => null,
                        onTap: () async {
                          final videoid = widget.searchResult![index].id.value;
                          //manifest for video bit rate
                          var manifest = await widget.yt!.videos.streamsClient
                              .getManifest(videoid);

                          //title of the video
                          final title = widget.searchResult![index].title;
                          //for likes , views , dislikes
                          final views = await widget
                              .searchResult![index].engagement.viewCount;

                          //video url
                          var video_url = await manifest.muxed.bestQuality.url;
                          //channelId
                          final chanenlId =
                              await widget.searchResult![index].channelId;

                          final channelData =
                              await widget.yt!.channels.get(chanenlId);
                          final descrption = widget
                              .searchResult![index].description
                              .toString();
                          final duration = widget.searchResult![index].duration;

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoUrl: video_url,
                              title: title,
                              channelData: channelData,
                              views: views,
                              description: descrption,
                              duration: duration!,
                              searchresult: widget.searchResult!,
                              yt: widget.yt,
                              currentVideoindex: index,
                            ),
                          ));
                        },
                        child: Container(
                          height: 225.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FittedBox(
                              child: Image.network(
                                widget.searchResult![index].thumbnails
                                    .standardResUrl,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30.h,
                        right: 5.w,
                        child: Container(
                          height: 20.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                              color: Color(0xff212121),
                              borderRadius: BorderRadius.circular(6.r)),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                  text:
                                      '${widget.searchResult![index].duration!.toString()} '
                                          .split(':')[1],
                                  children: [
                                    TextSpan(text: ':'),
                                    TextSpan(
                                        text:
                                            ':${widget.searchResult![index].duration!.toString()}'
                                                .split(':')[3]
                                                .split('.')
                                                .first)
                                  ]),
                              style: TextStyleMue(
                                fontSize: 12.sp,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FutureBuilder(
                        future: widget.yt!.channels
                            .get(widget.searchResult![index].channelId),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ClipOval(
                                  child: Container(
                                    height: 40.w,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.logoUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.w),
                        width: 250.w,
                        child: TextMue(
                            text: widget.searchResult![index].title,
                            fontSize: 12.sp,
                            weight: FontWeight.bold,
                            color: kblack,
                            maxlines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: PopupMenuButton<void Function()>(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: () async {
                                  final videoid =
                                      widget.searchResult![index].id.value;
                                  var manifest = await widget
                                      .yt!.videos.streamsClient
                                      .getManifest(videoid);
                                  var audioUrl =
                                      await manifest.audioOnly.first.url;

                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MusicPlayer(
                                      audiourl: audioUrl,
                                      albumName:
                                          widget.searchResult![index].title,
                                      thumbnail: widget.searchResult![index]
                                          .thumbnails.standardResUrl,
                                      duration:
                                          widget.searchResult![index].duration,
                                      artist:
                                          widget.searchResult![index].author,
                                    ),
                                  ));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.music_note_outlined,
                                      color: kpink,
                                    ),
                                    Text('Play as a Song'),
                                  ],
                                ),
                              ),
                            ];
                          },
                          onSelected: (fn) => fn(),
                        ),
                      )
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 55.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextMue(
                            text:
                                '${widget.searchResult![index].author}    .   ',
                            fontSize: 10.sp,
                            weight: FontWeight.w500,
                            color: const Color(0xff737374)),
                        TextMue(
                            text:
                                '${formatview.formatNumber(widget.searchResult![index].engagement.viewCount)} views',
                            fontSize: 10.sp,
                            weight: FontWeight.w500,
                            color: const Color(0xff737374)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  )
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     InkWell(
                  //       onTap: () async {
                  //         final videoid =
                  //             widget.searchResult![index].id.value;
                  //         var manifest = await widget.yt!.videos.streamsClient
                  //             .getManifest(videoid);
                  //         var audioUrl = await manifest.audioOnly.first.url;

                  //         Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => MusicPlayer(
                  //             audiourl: audioUrl,
                  //             albumName: widget.searchResult![index].title,
                  //             thumbnail: widget.searchResult![index]
                  //                 .thumbnails.standardResUrl,
                  //             duration: widget.searchResult![index].duration,
                  //             artist: widget.searchResult![index].author,
                  //           ),
                  //         ));
                  //       },
                  //       child: CircleAvatar(
                  //           backgroundColor: kyellow,
                  //           child: Icon(
                  //             Icons.music_note_rounded,
                  //             color: kblack,
                  //           )),
                  //     ),
                  //     SizedBox(
                  //       height: 10,
                  //     ),
                  //     InkWell(
                  //       onTap: () async {
                  //         log('pressed video button ');
                  //         final videoid =
                  //             widget.searchResult![index].id.value;
                  //         //manifest for video bit rate
                  //         var manifest = await widget.yt!.videos.streamsClient
                  //             .getManifest(videoid);

                  //         //title of the video
                  //         final title = widget.searchResult![index].title;
                  //         //for likes , views , dislikes
                  //         final views = await widget
                  //             .searchResult![index].engagement.viewCount;

                  //         //video url
                  //         var video_url =
                  //             await manifest.muxed.withHighestBitrate().url;
                  //         //channelId
                  //         final chanenlId =
                  //             await widget.searchResult![index].channelId;

                  //         final channelData =
                  //             await widget.yt!.channels.get(chanenlId);
                  //         final descrption = widget
                  //             .searchResult![index].description
                  //             .toString();
                  //         final duration =
                  //             widget.searchResult![index].duration;

                  //         Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => VideoPlayerScreen(
                  //             videoUrl: video_url,
                  //             title: title,
                  //             channelData: channelData,
                  //             views: views,
                  //             description: descrption,
                  //             duration: duration!,
                  //           ),
                  //         ));
                  //       },
                  //       child: CircleAvatar(
                  //         backgroundColor: kpink,
                  //         child: Icon(
                  //           Icons.videocam,
                  //           color: kblack,
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              )
            : SizedBox();
      },
    );
  }
}
