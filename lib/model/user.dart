import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String username;
  String email;
  String password;

  User(
      {this.id,
      required this.email,
      required this.password,
      required this.username});

  Map<String, dynamic> toJson() =>
      {'id': id, 'username': username, 'email': email, 'password': password};

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        email: snapshot['email'],
        id: snapshot['uid'],
        username: snapshot['username'],
        password: snapshot['password']);
  }
}
