import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/services/firestoremethods.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirestoreMethod _firestoreMethod = FirestoreMethod();
  TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.black, title: const Text('Comments')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        trailing: Text(DateFormat.yMMMd().format(snapshot
                            .data!.docs[index]['datePublished']
                            .toDate())),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data!.docs[index]['profilePic']),
                        ),
                        title: Text(snapshot.data!.docs[index]['name']),
                        subtitle: Text(
                          snapshot.data!.docs[index]['text'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }));
              },
            ),
          ),
          Container(
            height: 75,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePicUrl!),
                    backgroundColor: Colors.black,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                        hintText: 'Comment as ' + user.username + '....',
                        border: InputBorder.none),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      onPressed: () async {
                        _firestoreMethod.postComment(
                            widget.snap['postId'],
                            _commentController.text,
                            user.id,
                            user.username,
                            user.profilePicUrl!);
                        setState(() {
                          _commentController.clear();
                        });
                      },
                      child: const Text('send')),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
