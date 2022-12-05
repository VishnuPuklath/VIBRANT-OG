import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibrant_og/model/user.dart';

class Vibe {
  String? id;
  String? username;
  String? email;
  String? profilePicUrl;
  String? videoUrl;
  String? description;
  final List likes;

  Vibe(
      {required this.videoUrl,
      required this.likes,
      required this.id,
      required this.email,
      required this.description,
      required this.profilePicUrl,
      required this.username});

  Map<String, dynamic> toJson() => {
        'profilePicUrl': profilePicUrl,
        'username': username,
        'videoUrl': videoUrl,
        'description': description,
        'likes': likes,
        'id': id
      };

  static Vibe fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Vibe(
        likes: snapshot['likes'],
        id: snapshot['id'],
        email: snapshot['email'],
        username: snapshot['username'],
        profilePicUrl: snapshot['profilePicUrl'],
        videoUrl: snapshot['videoUrl'],
        description: snapshot['description']);
  }
}
