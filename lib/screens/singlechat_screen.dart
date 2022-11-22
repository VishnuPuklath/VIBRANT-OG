import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/providers/user_provider.dart';

class SingleChatScreen extends StatefulWidget {
  var user;
  SingleChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _messageController = TextEditingController();
  model.User? user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    String docid = Uuid().v1();

    return Scaffold(
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('chats')
              .doc(widget.user['id'])
              .collection('messages')
              .orderBy('Date')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  return Column(
                    crossAxisAlignment: snapshot.data!.docs[index]['sender'] !=
                            _auth.currentUser!.email
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data!.docs[index]['text'],
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                }),
              );
            } else {
              return Container(
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Say hi',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Image(
                      width: 50,
                      image: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdvdvtLfx2WS-CGMuknyReleJDt5Np8X3WB1lBqyaMTyCptopMM_L8waea9edVQKnRBtc&usqp=CAU'),
                    )
                  ],
                )),
              );
            }
          },
        )),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 20)),
                  )),
            )),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: Container(
                height: 45,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      try {
                        toChatList(_messageController.text);
                        toCurrentChatCollection();
                        toReceiverChatCollection();

                        setState(() {
                          _messageController.clear();
                        });
                      } catch (e) {
                        print(e.toString());
                      }
                    } else {
                      print('no text');
                    }
                  },
                  child: Text('SEND'),
                ),
              ),
            )
          ],
        )
      ]),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(widget.user['profilePic'])),
        ),
        title: Text(widget.user['username']),
      ),
    );
  }

  void toCurrentChatCollection() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('chats')
        .doc(widget.user['id'])
        .collection('messages')
        .add({
      'text': _messageController.text,
      'sender': _auth.currentUser!.email,
      'Date': DateTime.now(),
    });
  }

  void toReceiverChatCollection() async {
    await _firestore
        .collection('users')
        .doc(widget.user['id'])
        .collection('chats')
        .doc(_auth.currentUser!.uid)
        .collection('messages')
        .add({
      'text': _messageController.text,
      'sender': _auth.currentUser!.email,
      'Date': DateTime.now(),
    });
  }

  void toChatList(String msgTXT) async {
    String msgTxt = msgTXT;
    await _firestore
        .collection('userChatList')
        .doc(_auth.currentUser!.uid)
        .collection('message')
        .doc(widget.user['id'])
        .set({
      'sname': _auth.currentUser!.email,
      'rname': widget.user['email'],
      'text': msgTXT,
      'rpic': widget.user['profilePic'],
      'spic': user!.profilePicUrl,
    });

    await _firestore
        .collection('userChatList')
        .doc(widget.user['id'])
        .collection('message')
        .doc(_auth.currentUser!.uid)
        .set({
      'sname': _auth.currentUser!.email,
      'rname': widget.user['email'],
      'text': msgTXT,
      'rpic': widget.user['profilePic'],
      'spic': user!.profilePicUrl,
    });
  }
}















//  Container(
//           child: Center(
//               child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Text(
//                 'Say hi',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//               Image(
//                 width: 50,
//                 image: NetworkImage(
//                     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdvdvtLfx2WS-CGMuknyReleJDt5Np8X3WB1lBqyaMTyCptopMM_L8waea9edVQKnRBtc&usqp=CAU'),
//               )
//             ],
//           )),
//         )