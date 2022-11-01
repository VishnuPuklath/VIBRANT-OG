import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';

class VibeDetailBar extends StatelessWidget {
  String? username;
  String? description;
  String? profilePic;
  VibeDetailBar(
      {required this.username,
      required this.profilePic,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ListTile(
          horizontalTitleGap: 10,
          dense: true,
          minLeadingWidth: 0,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(profilePic == null
                ? 'https://hope.be/wp-content/uploads/2015/05/no-user-image.gif'
                : profilePic!),
            radius: 14,
          ),
          title: Text(
            username == null ? 'username' : username!,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        ExpandableText(
          description!,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          expandOnTextTap: true,
          maxLines: 1,
          expandText: 'more',
          collapseText: 'less',
        )
      ]),
    );
  }
}
