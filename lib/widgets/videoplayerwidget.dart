import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWid extends StatefulWidget {
  VideoPlayerWid({required this.videoloc, this.detu});

  String videoloc;
  var detu;

  @override
  State<VideoPlayerWid> createState() => _VideoPlayerWidState();
}

class _VideoPlayerWidState extends State<VideoPlayerWid> {
  bool? isPause;
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
          setState(() {
            isPause = true;
          });
        } else {
          videoPlayerController.play();
          setState(() {
            isPause = false;
          });
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: VideoPlayer(videoPlayerController),
                ),
                isPause == true
                    ? Positioned(
                        child: Align(
                            alignment: FractionalOffset.center,
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.grey,
                              size: 100,
                            )))
                    : SizedBox(),
                Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'Username : ' + widget.detu['username'],
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    widget.detu['description'],
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.only(right: 27),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_border,
                                  size: 39,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.black,
                  highlightColor: Colors.grey,
                  child: Container(
                    child: Center(child: CircularProgressIndicator()),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      color: Colors.green,
                                      width: 300,
                                      height: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.white,
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      color: Colors.pink,
                                      width: 300,
                                      height: 15,
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.only(right: 27),
                              child: Shimmer.fromColors(
                                baseColor: Colors.black,
                                highlightColor: Colors.grey,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    size: 39,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
