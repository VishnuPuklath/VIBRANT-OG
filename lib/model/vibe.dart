import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibrant_og/model/user.dart';

class Vibe {
  String? username;
  String? profilePicUrl;
  String? videoUrl;
  String? description;

  Vibe(
      {required this.videoUrl,
      required this.description,
      required this.profilePicUrl,
      required this.username});

  Map<String, dynamic> toJson() => {
        'profilePicUrl': profilePicUrl,
        'username': username,
        'videoUrl': videoUrl,
        'description': description
      };

  static Vibe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Vibe(
        username: snapshot['username'],
        profilePicUrl: snapshot['profilePicUrl'],
        videoUrl: snapshot['videoUrl'],
        description: snapshot['description']);
  }
}
