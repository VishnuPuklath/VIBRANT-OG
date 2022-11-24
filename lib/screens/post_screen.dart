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
              ))
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
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    print(snapshot.data!.docs[index]);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CommentScreen(
                                        snap: snapshot.data!.docs[index],
                                      );
                                    }));
                                  },
                                  icon: const Icon(
                                    Icons.comment,
                                    color: Colors.black,
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
                                                          .collection('posts')
                                                          .doc(snapshot.data!
                                                                  .docs[index]
                                                              ['postId'])
                                                          .delete();
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  content: Text(
                                                                      'Post Deleted')));
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.green),
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              Text(
                                snapshot.data!.docs[index]['username'] + ': ',
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                snapshot.data!.docs[index]['description'],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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

  void saveVibe(String postId, List saved, BuildContext context) async {
    try {
      if (saved.contains(postId)) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'savedpost': FieldValue.arrayRemove([postId])
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('unsaved')));
      } else {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'savedpost': FieldValue.arrayUnion([postId])
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('saved')));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
