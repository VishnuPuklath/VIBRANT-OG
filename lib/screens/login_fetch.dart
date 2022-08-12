import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/screens/home_screen.dart';

class LoginFetchScreen extends StatefulWidget {
  @override
  State<LoginFetchScreen> createState() => _LoginFetchScreenState();
}

class _LoginFetchScreenState extends State<LoginFetchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      )),
    );
  }

  void getData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (contex) {
      return HomeScreen();
    }));
  }
}
