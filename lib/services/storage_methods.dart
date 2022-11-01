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

  uploadVideo(String description, String videoPath) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      //get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage('Video $len', videoPath);
      Vibe vibe = Vibe(
          username: (userDoc.data()! as Map<String, dynamic>)['username'],
          profilePicUrl:
              (userDoc.data()! as Map<String, dynamic>)['profilePic'],
          videoUrl: videoUrl,
          description: description);
      await firestore.collection('videos').doc('video $len').set(vibe.toJson());
    } catch (e) {}
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = _firebaseStorage.ref().child('Videos').child(id);
    UploadTask uploadTask = ref.putFile(
      await _compressVideo(videoPath),
    );
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }
}


//  username: (userDoc.data()! as Map<String, dynamic>)['name'],