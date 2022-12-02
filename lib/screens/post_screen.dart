import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                                  IconButton(
                                      onPressed: () async {
                                        print(user.id);
                                        print('liked post');
                                        likePost(
                                            postId: snapshot.data!.docs[index]
                                                ['postId'],
                                            likes: snapshot.data!.docs[index]
                                                ['likes'],
                                            uid: user.id);
                                      },
                                      icon: snapshot.data!.docs[index]['likes']
                                              .contains(user.id)
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border_outlined,
                                              color: Colors.red,
                                            )),
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
                                      showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title: Text('Report Post'),
                                              content: const Text(
                                                  'Do you want to report this post to admin'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Container(
                                                              height: 250,
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      'Why are you reporting this post ?',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    const Divider(
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            'its a scam');
                                                                        // postReport(
                                                                        //     email: user
                                                                        //         .email,
                                                                        //     reason:
                                                                        //         'its a scam',
                                                                        //     postId:
                                                                        //         snapshot.data!.docs[index]['postId']);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Its a Scam'),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          17,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            'Nudity ');
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Nudity or sexual activity'),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          17,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            'Hate speech');
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Hate speech or symbol'),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          17,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            'False Information');
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'False Information'),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          17,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            'Violence');
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Violence'),
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          17,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            'Something else');
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          'Something else'),
                                                                    ),
                                                                  ]),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text('Yes')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('No'))
                                              ],
                                            );
                                          }));
                                    },
                                    icon: Icon(
                                      Icons.flag,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                snapshot.data!.docs[index]['likes'].length
                                        .toString() +
                                    ' likes',
                                style: TextStyle(color: Colors.white),
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
                                child: GestureDetector(
                                  onTap: () {
                                    print('Comments bottom sheet invoked');
                                    showModel(snapshot.data!.docs[index]);
                                  },
                                  child: const Text(
                                    'View all comments',
                                    style: TextStyle(color: Colors.grey),
                                  ),
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

  showModel(var snap) {
    return showBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 380,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Comments',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('posts')
                      .doc(snap['postId'])
                      .collection('comments')
                      .orderBy('datePublished', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            subtitle: Text(snapshot.data!.docs[index]['text']),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['profilePic']),
                              backgroundColor: Colors.amber,
                            ),
                            title: Text(snapshot.data!.docs[index]['name']),
                            trailing: Text(DateFormat.yMMMd().format(snapshot
                                .data!.docs[index]['datePublished']
                                .toDate())),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // void postReport(
  //     {required String postId,
  //     required reports,
  //     required String reason,
  //     required String email}) async {
  //   try {
  //     _firestore.collection('posts').doc(postId).update({
  //       'reports': {'reason': reason, 'reported by': email}
  //     });
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Reported')));
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
