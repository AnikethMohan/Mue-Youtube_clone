import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mue/const/styles.dart';
import 'package:mue/view/MusicPlayScreen/musicPlayer.dart';
import 'package:mue/view/VideoPlayer/video_player_screen.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchResults extends StatefulWidget {
  SearchResults({super.key, this.searchResult, this.yt});
  final VideoSearchList? searchResult;
  final YoutubeExplode? yt;

  @override
  State<SearchResults> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181A1F),
      appBar: AppBar(
        leadingWidth: 300,
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
              ),
            ),
            SizedBox(
              width: 10,
            ),
            TextMue(
                text: 'Search result', fontSize: 15, weight: FontWeight.bold)
          ],
        ),
      ),
      body: ListView(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.searchResult!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 30,
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 120,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Stack(
                            children: [
                              Image.network(widget.searchResult![index]
                                  .thumbnails.mediumResUrl),
                              Positioned(
                                bottom: 0,
                                right: 2,
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
                                    fontSize: 15,
                                    weight: FontWeight.w300,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 140,
                              child: TextMue(
                                  text: widget.searchResult![index].title
                                      .toString(),
                                  maxlines: 3,
                                  fontSize: 15,
                                  weight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            final videoid =
                                widget.searchResult![index].id.value;
                            var manifest = await widget.yt!.videos.streamsClient
                                .getManifest(videoid);
                            var audioUrl = await manifest.audioOnly.first.url;

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MusicPlayer(
                                audiourl: audioUrl,
                                albumName: widget.searchResult![index].title,
                                thumbnail: widget.searchResult![index]
                                    .thumbnails.standardResUrl,
                                duration: widget.searchResult![index].duration,
                                artist: widget.searchResult![index].author,
                              ),
                            ));
                          },
                          child: CircleAvatar(
                              backgroundColor: kyellow,
                              child: Icon(
                                Icons.music_note_rounded,
                                color: kblack,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            log('pressed video button ');
                            final videoid =
                                widget.searchResult![index].id.value;
                            //manifest for video bit rate
                            var manifest = await widget.yt!.videos.streamsClient
                                .getManifest(videoid);

                            //title of the video
                            final title = widget.searchResult![index].title;
                            //for likes , views , dislikes
                            final views = await widget
                                .searchResult![index].engagement.viewCount;

                            //video url
                            var video_url =
                                await manifest.muxed.withHighestBitrate().url;
                            //channelId
                            final chanenlId =
                                await widget.searchResult![index].channelId;

                            final channelData =
                                await widget.yt!.channels.get(chanenlId);
                            final descrption = widget
                                .searchResult![index].description
                                .toString();
                            final duration =
                                widget.searchResult![index].duration;

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoUrl: video_url,
                                title: title,
                                channelData: channelData,
                                views: views,
                                description: descrption,
                                duration: duration!,
                              ),
                            ));
                          },
                          child: CircleAvatar(
                            backgroundColor: kyellow,
                            child: Icon(
                              Icons.videocam,
                              color: kblack,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
