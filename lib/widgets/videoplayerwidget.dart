import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWid extends StatefulWidget {
  VideoPlayerWid({required this.videoloc});

  String videoloc;
  @override
  State<VideoPlayerWid> createState() => _VideoPlayerWidState();
}

class _VideoPlayerWidState extends State<VideoPlayerWid> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoloc);
    _initializeVideoPlayerFuture = videoPlayerController.initialize();
    videoPlayerController.addListener(() {});
    videoPlayerController.setLooping(true);
    videoPlayerController.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (videoPlayerController.value.isPlaying) {
          videoPlayerController.pause();
        } else {
          videoPlayerController.play();
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: VideoPlayer(videoPlayerController),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
