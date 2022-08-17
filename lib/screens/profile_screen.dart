import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/model/user.dart' as model;

import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1660480904370-a5dcd0be395b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNzd8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60')),
                color: Colors.purple[50],
              ),
              height: MediaQuery.of(context).size.height / 4,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 6,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePicUrl!),
                radius: 70,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 11),
          child: Column(children: [
            Text(
              user.username,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bio ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text(user.bio == null ? '' : user.bio!)
                      ]),
                ),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(color: Colors.brown[50]),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(user.email)
                      ]),
                ),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(color: Colors.brown[50]),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ]),
        )
      ],
    ));
  }
}
