import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String username;
  String email;
  String role;
  String password;
  String? profilePicUrl;
  String? bio;

  User(
      {required this.id,
      this.role = 'user',
      required this.email,
      required this.password,
      required this.username,
      this.profilePicUrl,
      this.bio});

  Map<String, dynamic> toJson() => {
        'role': role,
        'id': id,
        'bio': bio,
        'username': username,
        'email': email,
        'password': password,
        'profilePic': profilePicUrl
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      role: snapshot['role'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      id: snapshot['id'],
      username: snapshot['username'],
      profilePicUrl: snapshot['profilePic'],
      password: snapshot['password'],
    );
  }
}
