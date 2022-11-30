import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String? numberOfUsers;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Welcome Admin'),
          ),
          Center(
            child: numberOfUsers == null
                ? const Text('Loading')
                : Text(numberOfUsers!),
          )
        ],
      ),
    );
  }

  void getData() {
    QuerySnapshot<Map<String, dynamic>> snapshot = _firestore
        .collection('users')
        .get() as QuerySnapshot<Map<String, dynamic>>;
    setState(() {
      numberOfUsers = snapshot.docs.length.toString();
    });
  }
}
