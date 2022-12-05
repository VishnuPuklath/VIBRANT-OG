import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/services/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signup(
      {required username, required email, required password, file, bio}) async {
    String res = 'Some error occured';
    file ??= AssetImage('assets/nouser.png');
    try {
      if (email == 'admin@gmail.com') {
        res = 'Restricted email id .Please use another one';
      }
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);

      model.User user = model.User(
          bio: bio,
          email: email,
          profilePicUrl: photoUrl,
          password: password,
          username: username,
          id: cred.user!.uid);
      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJson());
      res = 'success';
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      res = e.message.toString();
    }
    return res;
  }

  Future<String> login({required email, required password}) async {
    String res = 'Error while logging';
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(cred.user!.uid).get();
      String role = snap['role'];
      if (role == 'user') {
        res = 'user';
      } else if (role == 'admin') {
        res = 'admin';
      }
    } on FirebaseException catch (e) {
      res = e.message.toString();
    }
    return res;
  }

  Future<model.User> getUserDetail() async {
    User? currentUser = _auth.currentUser;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    return model.User.fromSnap(snap);
  }
}
