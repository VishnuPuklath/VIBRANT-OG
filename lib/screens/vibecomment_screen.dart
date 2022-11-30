import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/providers/user_provider.dart';

class VibeCommentScreen extends StatefulWidget {
  VibeCommentScreen({required this.detu});
  var detu;

  @override
  State<VibeCommentScreen> createState() => _VibeCommentScreenState();
}

class _VibeCommentScreenState extends State<VibeCommentScreen> {
  TextEditingController _videoCommentController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  model.User? user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Comments',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 3,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('videos')
                      .doc(widget.detu['id'])
                      .collection('comments')
                      .orderBy('datePublished', descending: true)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                    .data!.docs[index]['profilePicUrl']),
                              ),
                              title: Text(snapshot.data!.docs[index]['name']),
                              subtitle:
                                  Text(snapshot.data!.docs[index]['comment']),
                              trailing: Text(DateFormat.yMMMd().format(snapshot
                                  .data!.docs[index]['datePublished']
                                  .toDate())),
                            );
                          }));
                    }
                    return Center(
                        child:
                            Text('No comments be the one who comment first'));
                  }))
            ]),
          ),
          Container(
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(user!.profilePicUrl!),
                ),
              ),
              Expanded(
                  child: TextFormField(
                controller: _videoCommentController,
                decoration: InputDecoration(
                    hintText: 'Comment as ' + user!.username,
                    contentPadding: EdgeInsets.only(left: 20)),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      postVideoComment();
                      _videoCommentController.clear();
                    },
                    child: Text('SEND')),
              )
            ]),
          )
        ],
      ),
    );
  }

  void postVideoComment() async {
    String videoCommentId = const Uuid().v1();
    await _firestore
        .collection('videos')
        .doc(widget.detu['id'])
        .collection('comments')
        .doc(videoCommentId)
        .set({
      'profilePicUrl': user!.profilePicUrl,
      'name': user!.username,
      'comment': _videoCommentController.text,
      'commentId': videoCommentId,
      'uid': user!.id,
      'datePublished': DateTime.now()
    });
  }
}
