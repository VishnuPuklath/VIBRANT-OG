import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/screens/chatlist_screen.dart';
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
    const PostScreen(),
    const ProfileScreen(),
    const Vibrant(),
    const ChatListScreen(),
    const ChatScreen()
  ];
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.black,
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_call_rounded), label: 'Vibrants'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.vibration), label: 'shakeNchat')
          ]),
    );
  }
}
