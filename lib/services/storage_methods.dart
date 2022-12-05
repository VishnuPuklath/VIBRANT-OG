import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:vibrant_og/model/vibe.dart';
import 'package:video_compress/video_compress.dart';

class StorageMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Add image to firebase storage

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref = _firebaseStorage
        .ref()
        .child(childName)
        .child(_firebaseAuth.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadVideo(String description, String videoPath) async {
    String res = 'upload failed';
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      //get id
      var allDocs = await firestore.collection('videos').get();

      String vid = Uuid().v1();
      String videoUrl = await _uploadVideoToStorage(vid, videoPath);
      Vibe vibe = Vibe(
          likes: [],
          id: vid,
          email: (userDoc.data()! as Map<String, dynamic>)['email'],
          username: (userDoc.data()! as Map<String, dynamic>)['username'],
          profilePicUrl:
              (userDoc.data()! as Map<String, dynamic>)['profilePic'],
          videoUrl: videoUrl,
          description: description);
      await firestore.collection('videos').doc(vid).set(vibe.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = _firebaseStorage.ref().child('Videos').child(id);
    UploadTask uploadTask = ref.putFile(
      await _compressVideo2(videoPath),
    );
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // _compressVideo(String videoPath) async {
  //   final compressedVideo = await VideoCompress.compressVideo(videoPath,
  //       quality: VideoQuality.MediumQuality);
  //   return compressedVideo!.file;
  // }

  _compressVideo2(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }
}
