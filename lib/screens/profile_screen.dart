import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/screens/login_screen.dart';
import 'package:vibrant_og/screens/profiledit_screen.dart';

import 'package:vibrant_og/services/storage_methods.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Uint8List? File;
  String? profilePic;
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'VIBRANT',
          style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => LoginScreen())));
              },
              child: const Icon(
                Icons.exit_to_app,
                size: 32,
              ))
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 18,
            ),
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: File == null
                      ? NetworkImage(user.profilePicUrl!)
                      : MemoryImage(File!) as ImageProvider,
                  radius: 70,
                  backgroundColor: Colors.amber,
                ),
                Positioned(
                  bottom: -9,
                  right: 6,
                  child: IconButton(
                    color: Colors.amberAccent[50],
                    onPressed: () {
                      print('Image need to change');
                      picChange();
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              user.username,
              style: const TextStyle(fontSize: 17),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfileEdit();
                }));
                print('Goes to edit page');
              },
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.blue, fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Email',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 5),
                        child: Text(user.email),
                      )
                    ]),
                color: Colors.brown[50],
                height: 50,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Bio',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 5),
                        child:
                            user.bio == null ? const Text('') : Text(user.bio!),
                      )
                    ]),
                color: Colors.brown[50],
                height: 50,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Mobile Number',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6, top: 5),
                        child: Text(''),
                      )
                    ]),
                color: Colors.brown[50],
                height: 50,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void picChange() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Select Image From'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              selectImage(ImageSource.gallery);
                            },
                            child: const Text('Gallery'),
                          ),
                          TextButton(
                            onPressed: () {
                              selectImage(ImageSource.camera);
                            },
                            child: const Text('Camera'),
                          )
                        ],
                      );
                    },
                  );
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              )
            ],
            title: const Text('Do you want to change your profile pic?'),
          );
        });
  }

  void selectImage(ImageSource source) async {
    Uint8List im = await pickImage(source);
    setState(() {
      File = im;
    });
    Navigator.pop(context);
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', File!, false);
      setState(() {
        profilePic = photoUrl;
      });

      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'profilePic': profilePic});
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.blue,
        content: Text('Updating......'),
      ),
    );
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('No image selected'),
      ),
    );
    Navigator.pop(context);
    print('No image selected');
  }

  void updateImage() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you want to update selected image?'),
            actions: [
              TextButton(
                onPressed: () {
                  print('Profile pic updated');
                },
                child: const Text('yes'),
              ),
              TextButton(
                onPressed: () {
                  print('cancel');
                  Navigator.pop(context);
                },
                child: const Text('No'),
              )
            ],
          );
        });
  }
}



// await _firestore
//         .collection('user')
//         .doc(_auth.currentUser!.uid)
//         .update({'profilePic': profilePic});