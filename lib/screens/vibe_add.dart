import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vibrant_og/screens/vibrant.dart';
import 'package:vibrant_og/services/authmethod.dart';
import 'package:vibrant_og/services/storage_methods.dart';
import 'package:video_player/video_player.dart';

class VibeAdd extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  VibeAdd({Key? key, required this.videoFile, required this.videoPath});
  @override
  State<VibeAdd> createState() => _VibeAddState();
}

class _VibeAddState extends State<VibeAdd> {
  // late VideoPlayerController videoPlayerController;
  final TextEditingController _descriptionController = TextEditingController();
  late VideoPlayerController controller;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(0.5);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('add vibe'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            color: Colors.amber,
            height: 500,
            child: VideoPlayer(controller),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                if (_descriptionController.text.isNotEmpty) {
                  String res = await StorageMethods().uploadVideo(
                      _descriptionController.text, widget.videoPath);
                  print('res from vibe add' + res);
                  if (res == 'success') {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Vibrant();
                    }));
                  }
                } else {
                  print('empty');
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Post Vibe'),
            ),
          ),
        ]),
      ),
    );
  }
}
