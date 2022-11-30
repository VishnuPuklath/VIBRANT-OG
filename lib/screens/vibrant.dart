import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibrant_og/screens/vibe_add.dart';
import 'package:vibrant_og/widgets/sideactionbar.dart';
import 'package:vibrant_og/widgets/vibedetailbar.dart';
import 'package:vibrant_og/widgets/videoplayerwidget.dart';
import 'package:video_player/video_player.dart';

class Vibrant extends StatefulWidget {
  const Vibrant({Key? key}) : super(key: key);

  @override
  State<Vibrant> createState() => _VibrantState();
}

class _VibrantState extends State<Vibrant> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List reelsoli = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'VIBES',
          style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              showOptionDialog(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) {
              //     return VibeAdd();
              //   }),
              // );
            },
            child: const Icon(
              Icons.video_call,
              size: 32,
            ),
          ),
        ],
      ),
      body: PageView.builder(
          itemCount: reelsoli.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            print(reelsoli[index]);
            return Container(
              child: VideoPlayerWid(
                  videoloc: reelsoli[index]['videoUrl'], detu: reelsoli[index]),
            );
          }),
    );
  }

  showOptionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () {
                pickVideo(ImageSource.gallery, context);
              },
              child: Row(
                children: const [
                  Icon(Icons.image),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text('Gallery'),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                pickVideo(ImageSource.camera, context);
              },
              child: Row(children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text('Camera'),
                )
              ]),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const [
                  Icon(Icons.cancel),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text('cancel'),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void pickVideo(ImageSource src, BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VibeAdd(
              videoFile: File(video.path),
              videoPath: video.path,
            );
          },
        ),
      );
    }
  }

  getVideos() async {
    print('getvideocalled');
    CollectionReference videos = _firestore.collection('videos');
    QuerySnapshot allResults = await videos.get();
    allResults.docs.forEach((DocumentSnapshot result) {
      setState(() {
        reelsoli.add(result.data());
      });
    });
    print(reelsoli.length);
    print(reelsoli);
    return reelsoli;
  }
}
