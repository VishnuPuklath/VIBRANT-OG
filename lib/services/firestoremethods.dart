import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'text': text,
          'uid': uid,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print('comment text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
