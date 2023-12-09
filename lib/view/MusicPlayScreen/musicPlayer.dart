import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mue/const/credientials.dart';
import 'package:mue/const/styles.dart';
import 'package:spotify/spotify.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer(
      {super.key,
      this.audiourl,
      this.albumName,
      this.thumbnail,
      this.duration,
      this.artist});
  final audiourl;
  final albumName;
  final thumbnail;
  final artist;
  Duration? duration;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  String trackId = '6rWblGW0pBcB3uygxBuWZV';
  final player = AudioPlayer();
  Pages<AlbumSimple>? lists;
  String? response;
  String? responseUri;
  String? image;
  Duration? videoDuration;

  @override
  void initState() {
    final credentials =
        SpotifyApiCredentials(Credentials.clientId, Credentials.clientSecret);
    final spotify = SpotifyApi(credentials);
    // final grant = SpotifyApi.authorizationCodeGrant(credentials);
    // final redirectUri = 'http://localhost:8888/callback';

    final scopes = [
      AuthorizationScope.user.readEmail,
      AuthorizationScope.library.read
    ];
    // final authUri = grant.getAuthorizationUrl(
    //   Uri.parse(redirectUri),
    //   scopes: scopes, // scopes are optional
    // );

    // redirect(authUri, redirectUri);

    // final me = spotify.users;
    // final profile = me.get('yor0ldijhpv91zrb9wzxg7423').then((value) {
    //   print('name is ${value.displayName.toString()}');
    // });

    final artist = spotify.tracks.get(trackId).then((track) async {
      String? songName = track.name;
      String? song = track.uri.toString();
      if (songName != null) {
        final yt = YoutubeExplode();

        setState(() {
          videoDuration = widget.duration;
        });

        await player.play(UrlSource(widget.audiourl.toString()));
      }
    });
    // final link = linkStream.listen((event) async {
    //   if (event!.startsWith(redirectUri)) {
    //     print('response is ${event.toString()}');
    //     responseUri = event;
    //   }
    // });
    // final profiles = spotify.me;

    // final data = profiles.topTracks;

    // print('data is $data ');

    // print('linkd is ${link.toString()}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181A1F),
      appBar: AppBar(
        leading: InkWell(
          onTap: () async {
            await player.stop();

            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(widget.thumbnail.toString()))),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextMue(
              text: '${widget.albumName}',
              fontSize: 25,
              weight: FontWeight.bold,
              align: TextAlign.center,
              color: kwhite),
          const SizedBox(
            height: 10,
          ),
          widget.artist != null
              ? TextMue(
                  text: '${widget.artist}',
                  fontSize: 17,
                  weight: FontWeight.w600,
                  color: kwhite)
              : SizedBox(),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Color(0xff464646),
            endIndent: 20,
            indent: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
              stream: player.onPositionChanged,
              builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ProgressBar(
                    thumbColor: kyellow,
                    baseBarColor: Color(0xff35373D),
                    progressBarColor: kyellow,
                    progress: snapshot.data ?? Duration(seconds: 0),
                    bufferedBarColor: Color.fromARGB(255, 193, 194, 197),
                    buffered: Duration(seconds: 5),
                    total: widget.duration ?? Duration(minutes: 0),
                    timeLabelTextStyle:
                        TextStyleMue(fontSize: 12, weight: FontWeight.bold),
                    onSeek: (duration) {
                      player.seek(duration);
                    },
                  ),
                );
              }),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    final durations = await player.getCurrentPosition();
                    if (durations != null) {
                      player.seek(durations - Duration(seconds: 10));
                    }
                  },
                  icon: const Icon(
                    Icons.replay_10_rounded,
                    size: 35,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 10.w,
              ),
              Play_button(),
              SizedBox(
                width: 10.w,
              ),
              IconButton(
                  onPressed: () async {
                    final durations = await player.getCurrentPosition();
                    if (durations != null) {
                      player.seek(durations + Duration(seconds: 10));
                    }
                  },
                  icon: const Icon(
                    Icons.forward_10_rounded,
                    size: 35,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      ),
    );
  }

  CircleAvatar Play_button() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: kyellow,
      child: StreamBuilder<Object>(
          stream: player.onPositionChanged,
          builder: (context, snapshot) {
            return IconButton(
              onPressed: () async {
                setState(() {});
                player.state == PlayerState.playing
                    ? await player.pause()
                    : await player.resume();
                setState(() {});
              },
              icon: player.state == PlayerState.playing
                  ? Icon(
                      Icons.pause_outlined,
                      size: 30,
                      color: Color(0xff181A1F),
                    )
                  : Icon(
                      Icons.play_arrow_rounded,
                      size: 30,
                      color: Color(0xff181A1F),
                    ),
            );
          }),
    );
  }

  void redirect(Uri authUri, String redirectUri) async {
    if (await canLaunchUrl(authUri)) {
      await launchUrl(authUri);
    }
    // final linksStream = getLinksStream().listen((String link) async {
    //   if (link.startsWith(redirectUri)) {
    //     response. = link;
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();

    super.dispose();
  }
}
