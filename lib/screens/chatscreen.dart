import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:vibrant_og/screens/login_screen.dart';
import 'package:vibrant_og/screens/singlechat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  List users = [];
  var randomUser;
  late ShakeDetector detector;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detector = ShakeDetector.autoStart(
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        shakeThresholdGravity: 2.7,
        minimumShakeCount: 1,
        onPhoneShake: () async {
          print('Shaked');
          await getUsers();
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    detector.stopListening();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) => LoginScreen()),
                ),
              );
            },
            child: const Icon(
              Icons.exit_to_app,
              size: 32,
            ),
          )
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                getUsers();
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                width: double.infinity,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Image(
                          image: NetworkImage(
                              'https://static.vecteezy.com/system/resources/thumbnails/007/480/361/small/sticker-smartphone-shake-suitable-for-web-interface-symbol-simple-design-editable-design-template-simple-symbol-illustration-vector.jpg'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Shake for Chat',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        users.length > 0
            ? ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Text('Message'),
                      onPressed: () {
                        print(users[0]);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SingleChatScreen(
                            user: users[0],
                          );
                        }));
                      },
                    ),
                    subtitle: Text(users[0]['email']),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(users[0]['profilePic']),
                    ),
                    title: Text(users[0]['username']),
                  )
                ],
              )
            : const Text('Shake for users')
      ]),
    );
  }

  Future getUsers() async {
    print('getusers called');
    await for (var snapshot
        in FirebaseFirestore.instance.collection('users').snapshots()) {
      for (var user in snapshot.docs) {
        if (user.id != _auth.currentUser!.uid &&
            user.id != 'rvp8XTNFvsN3FFmQ5dLQtn5A3mH3') {
          users.add(user.data());
          print(user.data());
        }
      }
      setState(() {
        randomUser = (users..shuffle()).first;
      });
    }
  }
}
