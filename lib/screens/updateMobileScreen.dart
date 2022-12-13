import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/services/authmethod.dart';
import 'package:vibrant_og/widgets/showOtp.dart';

class Mobile extends StatefulWidget {
  const Mobile({Key? key}) : super(key: key);

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  UserProvider _provider = UserProvider();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _smsController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  String smsCode = '';
  String verificationId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add mobile number'),
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _mobileController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                if (_mobileController.text.isNotEmpty) {
                  phoneUpdate(context, _mobileController.text);
                }
              },
              child: const Text('SEND OTP'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> phoneUpdate(BuildContext context, String phoneNumber) async {
    TextEditingController codeController = TextEditingController();
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91' + phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        _auth.currentUser!.updatePhoneNumber(credential);
        _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'mobile': phoneNumber});
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message!),
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) async {
        showOTP(
          context: context,
          controller: codeController,
          onPressed: () {
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: codeController.text.trim(),
            );
            _auth.currentUser!.updatePhoneNumber(credential);
            _firestore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .update({'mobile': phoneNumber});

            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
