import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibrant_og/screens/login_screen.dart';
import 'package:vibrant_og/screens/savedpostscreen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with TickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((context) => LoginScreen())));
                },
                child: const Icon(
                  Icons.exit_to_app,
                  size: 32,
                ))
          ],
        ),
        body: Column(
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.1),
                ),
                child: TabBar(
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.amber),
                    controller: tabController,
                    tabs: const [
                      Text(
                        'Posts',
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Vibrants',
                        style: TextStyle(color: Colors.black),
                      )
                    ]),
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: [
                SavedPostScreen(),
                Center(child: Text('Vibrants content here'))
              ],
            ))
          ],
        ));
  }
}
