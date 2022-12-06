import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/screens/vibecomment_screen.dart';
import 'package:vibrant_og/screens/vibrant.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:video_player/video_player.dart';

class VideoPlayerWid extends StatefulWidget {
  VideoPlayerWid({required this.videoloc, this.detu});

  String videoloc;
  var detu;

  @override
  State<VideoPlayerWid> createState() => _VideoPlayerWidState();
}

class _VideoPlayerWidState extends State<VideoPlayerWid> {
  String? commentsCount;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool? isPause;
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCount();
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
    model.User? user = Provider.of<UserProvider>(context).getUser;
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
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection('videos')
            .where('id', isEqualTo: widget.detu['id'])
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                snapshot.data!.docs;
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: VideoPlayer(videoPlayerController),
                ),
                isPause == true
                    ? const Positioned(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: Icon(
                            Icons.play_circle,
                            color: Colors.grey,
                            size: 100,
                          ),
                        ),
                      )
                    : SizedBox(),
                Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      widget.detu['profilePicUrl'])),
                              Text(
                                ' ' + docs[0]['username'].toString(),
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  ': ' + docs[0]['description'].toString(),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ]),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 27),
                                  child: docs[0]['username'] == user.username
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Delete?',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    content: const Text(
                                                        'Are you sure you want to delete?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          String res =
                                                              await deleteVideo();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                res,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                          );
                                                          if (res ==
                                                              'Deleted') {
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                return Vibrant();
                                                              }),
                                                            );
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Yes',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          'No',
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 39,
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 27),
                                  child: IconButton(
                                    onPressed: () {
                                      showBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return VibeCommentScreen(
                                              detu: widget.detu,
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.comment,
                                      color: Colors.white,
                                      size: 39,
                                    ),
                                  ),
                                ),
                                commentsCount == null
                                    ? const Padding(
                                        padding: EdgeInsets.only(right: 27),
                                        child: Text(
                                          '0',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 27),
                                        child: StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          stream: _firestore
                                              .collection('videos')
                                              .doc(widget.detu['id'])
                                              .collection('comments')
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                snapshot.data.docs.length
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              );
                                            } else {
                                              return Text('..');
                                            }
                                          },
                                        )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 27),
                                  child: IconButton(
                                    onPressed: () async {
                                      print('Like pressed');
                                      likeVibe(
                                          likes: docs[0]['likes'],
                                          uid: user.id,
                                          vid: widget.detu['id']);
                                    },
                                    icon: docs[0]['likes'].contains(user.id)
                                        ? const Icon(
                                            Icons.favorite,
                                            size: 39,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            size: 39,
                                            color: Colors.red,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 27),
                                  child: Text(
                                    docs[0]['likes'].length.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
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
                                  const SizedBox(
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
                                  const SizedBox(
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

  Future<String> deleteVideo() async {
    String res = 'failed to delete';
    try {
      _firestore.collection('videos').doc(widget.detu['id']).delete();
      _firebaseStorage.ref().child('Videos').child(widget.detu['id']).delete();
      res = 'Deleted';
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }
    return res;
  }

  getCount() async {
    var snapshot = await _firestore
        .collection('videos')
        .doc(widget.detu['id'])
        .collection('comments')
        .get();
    print(snapshot.docs.length);
    setState(() {
      commentsCount = snapshot.docs.length.toString();
    });
  }

  Stream getData() {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot =
        _firestore.collection('videos').doc('widget.videoloc').snapshots();
    return snapshot;
  }

  void likeVibe(
      {required String vid, required String uid, required List likes}) async {
    if (likes.contains(uid)) {
      _firestore.collection('videos').doc(vid).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      _firestore.collection('videos').doc(vid).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
