import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/model/user.dart' as model;

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.black, title: const Text('Comments')),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(
            child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(user.profilePicUrl!),
                    ),
                    title: const Text('Heloooooo'),
                    trailing: const Text(
                      '22-08-22',
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                }),
          ),
          Row(
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
                    onPressed: () {},
                    child: const Text('send')),
              )
            ],
          )
        ]),
      ),
    );
  }
}
