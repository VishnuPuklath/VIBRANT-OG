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
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('savedpost')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Image(
                      fit: BoxFit.contain,
                      image: NetworkImage(snapshot.data!.docs[0]['photoUrl']),
                    ),
                  ),
                );
              },
            );
          }
          if (!snapshot.hasData) {
            return Text('No saved post available');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
