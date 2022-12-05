import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/screens/singlechat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var admin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdmin();
  }

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
              return Column(
                children: [
                  ListTile(
                      onTap: () async {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SingleChatScreen(user: admin);
                        }));
                      },
                      trailing: const Icon(Icons.admin_panel_settings),
                      subtitle: const Text('Tap to Chat with admin'),
                      title: const Text('Admin'),
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/admin.png'),
                      )),
                  const Divider(
                    color: Colors.black,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return snapshot.data!.docs[index]['email'] ==
                                _auth.currentUser!.email
                            ? InkWell(
                                onTap: () async {
                                  var usero = await _firestore
                                      .collection('users')
                                      .doc(snapshot.data!.docs[index]['id'])
                                      .get()
                                      .then((DocumentSnapshot) =>
                                          DocumentSnapshot.data());
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SingleChatScreen(user: usero);
                                  }));
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data!.docs[index]['spic'])),
                                      title: Center(
                                          child: Text(snapshot.data!.docs[index]
                                              ['sname'])),
                                      subtitle: Center(
                                          child: Text(snapshot.data!.docs[index]
                                              ['text'])),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  var usero = await _firestore
                                      .collection('users')
                                      .doc(snapshot.data!.docs[index]['id'])
                                      .get()
                                      .then((DocumentSnapshot) =>
                                          DocumentSnapshot.data());
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SingleChatScreen(user: usero);
                                  }));
                                },
                                child: snapshot.data!.docs[index]['email'] !=
                                        'admin@gmail.com'
                                    ? Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data!.docs[index]
                                                        ['rpic'])),
                                            title: Center(
                                              child: Text(snapshot
                                                  .data!.docs[index]['email']),
                                            ),
                                            subtitle: Center(
                                              child: Text(snapshot
                                                  .data!.docs[index]['text']),
                                            ),
                                          ),
                                          const Divider(
                                            color: Colors.black,
                                          )
                                        ],
                                      )
                                    : SizedBox(),
                              );
                      })),
                ],
              );
            } else {
              return const Center(
                child: Text('No Chats to show'),
              );
            }
          },
        ));
  }

  void getAdmin() async {
    var snapshot = await _firestore
        .collection('users')
        .doc('rvp8XTNFvsN3FFmQ5dLQtn5A3mH3')
        .get();
    print(snapshot.data());
    setState(() {
      admin = snapshot.data();
    });
  }
}
