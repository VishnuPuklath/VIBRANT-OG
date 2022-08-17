import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:vibrant_og/screens/home_screen.dart';
import 'package:vibrant_og/screens/login_fetch.dart';
import 'package:vibrant_og/screens/register_screen.dart';
import 'package:vibrant_og/services/authmethod.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();

  TextEditingController _PasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 200,
            height: 100,
            child: Stack(children: [
              Image.asset('assets/vibsplash.jpg'),
              Positioned(
                  bottom: 25,
                  left: 39,
                  child: Text(
                    'VIBRANT',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontStyle: FontStyle.italic,
                      fontSize: 35,
                    ),
                  ))
            ]),
          ),
        ]),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: _PasswordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          height: 43,
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (_emailController.text.isNotEmpty &&
                  _PasswordController.text.isNotEmpty) {
                String res = await AuthMethods().login(
                    email: _emailController.text,
                    password: _PasswordController.text);
                if (res != 'success') {
                  Future.delayed(
                      const Duration(
                        seconds: 1,
                      ), () {
                    setState(() {
                      isLoading = false;
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(res),
                    ),
                  );
                }
                if (res == 'success') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginFetchScreen();
                      },
                    ),
                  );
                }
              } else {
                Future.delayed(
                    const Duration(
                      seconds: 1,
                    ), () {
                  setState(() {
                    isLoading = false;
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Please enter all fields'),
                  ),
                );
              }
            },
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : Text('Login'),
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.black, primary: Colors.pink),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Don\'t have an account ?'),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return RegisterScreen();
                  }));
                },
                child: Text('Register'))
          ],
        )
      ]),
    );
  }
}
