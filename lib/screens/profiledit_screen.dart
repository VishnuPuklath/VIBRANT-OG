import 'package:flutter/material.dart';
import 'package:vibrant_og/widgets/textfield.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Profile Edit')),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Txtfd(hintText: 'Username', controller: _usernameController)
        ],
      ),
    );
  }
}
