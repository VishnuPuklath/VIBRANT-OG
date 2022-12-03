import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibrant_og/screens/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String? numberOfUsers;
  String? numberOfPosts;
  String? numberOfrposts;
  String? numberOfVideos;
  bool? isLoading;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                print('pressed');
                _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => LoginScreen())));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
        title: const Text('Admin'),
        backgroundColor: Colors.black,
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : Column(
              children: [
                Expanded(
                  child: Container(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: [
                        Card(
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Number of Users'),
                              Text(numberOfUsers == null
                                  ? '0'
                                  : numberOfUsers.toString()),
                            ],
                          )),
                        ),
                        Card(
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Number of Posts'),
                              Text(numberOfPosts == null
                                  ? '0'
                                  : numberOfPosts.toString())
                            ],
                          )),
                        ),
                        Card(
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Number of Reported post'),
                              Text(numberOfrposts == null
                                  ? '0'
                                  : numberOfrposts.toString())
                            ],
                          )),
                        ),
                        Card(
                          child: Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Number of Videos'),
                              Text(numberOfVideos == null
                                  ? '0'
                                  : numberOfVideos.toString()),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot users = await _firestore.collection('users').get();
    QuerySnapshot posts = await _firestore.collection('posts').get();
    QuerySnapshot videos = await _firestore.collection('videos').get();
    QuerySnapshot report = await _firestore
        .collection('posts')
        .where('reports', isNull: false)
        .get();

    setState(() {
      numberOfUsers = users.docs.length.toString();
      numberOfPosts = posts.docs.length.toString();
      numberOfrposts = report.docs.length.toString();
      numberOfVideos = videos.docs.length.toString();
    });

    setState(() {
      isLoading = false;
    });
  }
}
