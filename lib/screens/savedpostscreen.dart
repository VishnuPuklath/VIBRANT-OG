import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SavedPostScreen extends StatefulWidget {
  const SavedPostScreen({Key? key}) : super(key: key);

  @override
  State<SavedPostScreen> createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends State<SavedPostScreen> {
  List savedPost = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsavedList();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _firestore.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if (savedPost.contains(snapshot.data!.docs[index]['postId'])) {
                  //print(snapshot.data!.docs[index]['photoUrl']);
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Image(
                      fit: BoxFit.contain,
                      image:
                          NetworkImage(snapshot.data!.docs[index]['postUrl']),
                    ),
                  ),
                );
              },
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No saved post available'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List> getsavedList() async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    var savedPost1 = snapshot.get('savedpost');
    print(savedPost1);
    print('got it?');
    setState(() {
      savedPost = savedPost1;
    });
    return savedPost;
  }
}
