import 'package:flutter/material.dart';

class SideActionBar extends StatelessWidget {
  const SideActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        IconButton(
          onPressed: () {
            print('Vibe liked');
          },
          icon: const Icon(Icons.favorite),
        ),
        const Text('Likes'),
        IconButton(
          onPressed: () {
            print('comment cliked');
          },
          icon: const Icon(Icons.comment),
        ),
        const Text('3'),
        IconButton(
          onPressed: () {
            print('More cliked');
          },
          icon: const Icon(Icons.more_horiz),
        ),
        const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1661123147442-d6539ebd2bf2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60'),
        )
      ]),
    );
  }
}
