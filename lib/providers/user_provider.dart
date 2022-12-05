import 'package:flutter/cupertino.dart';
import 'package:vibrant_og/model/user.dart';
import 'package:vibrant_og/services/authmethod.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User get getUser => _user!;

  Future<User> refreshUser() async {
    User user = await AuthMethods().getUserDetail();
    _user = user;
    notifyListeners();
    return user;
  }
}
