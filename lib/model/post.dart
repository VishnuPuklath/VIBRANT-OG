import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String postId;
  String uid;
  String username;
  String description;
  String photoUrl;
  String datePublished;
  String postUrl;
  final likes;
  final reports;

  Post(
      {required this.postId,
      this.reports,
      required this.likes,
      required this.uid,
      required this.postUrl,
      required this.username,
      required this.description,
      required this.photoUrl,
      required this.datePublished});

  Map<String, dynamic> toJson() => {
        'likes': likes,
        'reports': reports,
        'postId': postId,
        'uid': uid,
        'username': username,
        'description': description,
        'photoUrl': photoUrl,
        'datePublished': datePublished,
        'postUrl': postUrl
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        likes: snapshot['likes'],
        reports: snapshot['reports'],
        uid: snapshot['uid'],
        postId: snapshot['postId'],
        postUrl: snapshot['username'],
        username: snapshot['username'],
        description: snapshot['description'],
        photoUrl: snapshot['photoUrl'],
        datePublished: snapshot['datepublished']);
  }
}
