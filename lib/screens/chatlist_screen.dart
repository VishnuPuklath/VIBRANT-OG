import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/providers/user_provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black, title: Text('Chats')),
        body: StreamBuilder(
          stream: _firestore
              .collection('userChatList')
              .doc(_auth.currentUser!.uid)
              .collection('message')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              print(snapshot.data!.docs);
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return snapshot.data!.docs[index]['rname'] ==
                            _auth.currentUser!.email
                        ? Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.docs[index]['spic'])),
                                title: Center(
                                    child: Text(
                                        snapshot.data!.docs[index]['sname'])),
                                subtitle: Center(
                                    child: Text(
                                        snapshot.data!.docs[index]['text'])),
                              ),
                              const Divider(
                                color: Colors.black,
                              )
                            ],
                          )
                        : Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.docs[index]['rpic'])),
                                title: Center(
                                    child: Text(
                                        snapshot.data!.docs[index]['rname'])),
                                subtitle: Center(
                                    child: Text(
                                        snapshot.data!.docs[index]['text'])),
                              ),
                              const Divider(
                                color: Colors.black,
                              )
                            ],
                          );
                  }));
            } else {
              return const Center(
                child: Text('No Chats to show'),
              );
            }
          },
        ));
  }
}
