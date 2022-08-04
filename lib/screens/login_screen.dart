import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:vibrant_og/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                decoration: InputDecoration(
                  hintText: 'Username',
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
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: 200,
          child: ElevatedButton(
              onPressed: () {},
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black, primary: Colors.pink)),
        ),
        SizedBox(
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
