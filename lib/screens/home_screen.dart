import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/screens/chatscreen.dart';
import 'package:vibrant_og/screens/favourites.dart';
import 'package:vibrant_og/screens/login_screen.dart';
import 'package:vibrant_og/screens/post_screen.dart';
import 'package:vibrant_og/screens/profile_screen.dart';
import 'package:vibrant_og/screens/vibrant.dart';
import 'package:vibrant_og/services/authmethod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  int selectedIndex = 0;
  List screens = [
    PostScreen(),
    ProfileScreen(),
    Vibrant(),
    FavouriteScreen(),
    ChatScreen()
  ];
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
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
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.amberAccent,
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_call_rounded), label: 'Vibrants'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline_rounded),
                label: 'favourites'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chats')
          ]),
    );
  }
}
