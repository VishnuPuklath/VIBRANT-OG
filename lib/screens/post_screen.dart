import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/model/post.dart';
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/screens/add_post.dart';
import 'package:vibrant_og/screens/comments_screen.dart';
import 'package:vibrant_og/screens/login_screen.dart';
import 'package:vibrant_og/screens/vibrant.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'VIBRANT',
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
              _auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => LoginScreen())));
            },
            child: const Icon(
              Icons.exit_to_app,
              size: 32,
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: Image.network(
                                      snapshot.data!.docs[index]['photoUrl'],
                                    ).image,
                                    backgroundColor: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    snapshot.data!.docs[index]['username'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: SizedBox(
                                height: 400,
                                width: double.infinity,
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    snapshot.data!.docs[index]['postUrl'],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  LikeButton(
                                    onTap: (isLiked) {
                                      return likePost(
                                          postId: snapshot.data!.docs[index]
                                              ['postId'],
                                          likes: snapshot.data!.docs[index]
                                              ['likes'],
                                          uid: user.id);
                                    },
                                    isLiked: snapshot.data!.docs[index]['likes']
                                        .contains(user.id),
                                    size: 27,
                                    likeCount: snapshot
                                        .data!.docs[index]['likes'].length,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        print(snapshot.data!.docs[index]);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CommentScreen(
                                            snap: snapshot.data!.docs[index],
                                          );
                                        }));
                                      },
                                      icon: const Icon(
                                        Icons.comment,
                                        color: Colors.white,
                                      )),
                                  snapshot.data!.docs[index]['uid'] ==
                                          _auth.currentUser!.uid
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Are you sure you want to delete this post?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          _firestore
                                                              .collection(
                                                                  'posts')
                                                              .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index]
                                                                  ['postId'])
                                                              .delete();
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Text(
                                                                  'Post Deleted'),
                                                            ),
                                                          );
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                      : const SizedBox(),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      postReport(
                                          uid: user.id,
                                          reports: snapshot.data!.docs[index]
                                              ['reports'],
                                          postId: snapshot.data!.docs[index]
                                              ['postId']);
                                    },
                                    icon: snapshot.data!.docs[index]['reports']
                                            .contains(user.id)
                                        ? const Icon(
                                            Icons.flag,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.flag,
                                            color: Colors.white,
                                          ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  Text(
                                    snapshot.data!.docs[index]['username'] +
                                        ': ',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['description'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'Published on ' +
                                      snapshot.data!.docs[index]
                                          ['datePublished'],
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 2,
                            )
                          ]),
                    ));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const AddPostScreen();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    bool isLiked = false;
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
        isLiked = false;
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
        isLiked = true;
      }
    } catch (e) {
      print(e.toString());
    }
    return isLiked;
  }

  void postReport({
    required String uid,
    required String postId,
    required List reports,
  }) async {
    try {
      if (reports.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'reports': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'reports': FieldValue.arrayUnion([uid]),
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text('Post Reported')));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}


//  IconButton(
//                                       onPressed: () async {
                                     
//                                       },
//                                       icon: snapshot.data!.docs[index]['likes']
//                                               .contains(user.id)
//                                           ? Icon(
//                                               Icons.favorite,
//                                               color: Colors.red,
//                                             )
//                                           : Icon(
//                                               Icons.favorite_border_outlined,
//                                               color: Colors.red,
//                                             ))

