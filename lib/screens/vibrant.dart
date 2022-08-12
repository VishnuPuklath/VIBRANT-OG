import 'package:flutter/material.dart';

class Vibrant extends StatefulWidget {
  const Vibrant({Key? key}) : super(key: key);

  @override
  State<Vibrant> createState() => _VibrantState();
}

class _VibrantState extends State<Vibrant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Vibrants')),
    );
  }
}
