import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/screens/login_screen.dart';
import 'package:vibrant_og/screens/updateMobileScreen.dart';
import 'package:vibrant_og/services/storage_methods.dart';
import 'package:vibrant_og/widgets/showOtp.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _bioController = TextEditingController();
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) => LoginScreen()),
                ),
              );
            },
            child: const Icon(
              Icons.exit_to_app,
              size: 32,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _firestore.collection('users').doc(user.id).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
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
                            ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                                  padding:
                                      const EdgeInsets.only(left: 6, top: 5),
                                  child: snapshot.data['bio'] == null
                                      ? const Text('')
                                      : Text(snapshot.data['bio']),
                                )
                              ]),
                          IconButton(
                            onPressed: () {
                              showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    color: Colors.black,
                                    height: 300,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Update Bio',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, right: 5, left: 5),
                                          child: Container(
                                            color: Colors.white,
                                            child: TextFormField(
                                              controller: _bioController,
                                              decoration: const InputDecoration(
                                                  hintText: 'Bio',
                                                  hintStyle: TextStyle(
                                                      color: Colors.white),
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.teal),
                                            onPressed: () async {
                                              if (_bioController
                                                  .text.isNotEmpty) {
                                                String res = await updateBio(
                                                    id: user.id,
                                                    bio: _bioController.text);
                                                Navigator.of(context).pop();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(res.toString()),
                                                  backgroundColor: Colors.green,
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Please enter bio'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Update'))
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                          )
                        ],
                      ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Mobile Number',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, top: 5),
                                  child: user.mobile == null
                                      ? const Text('')
                                      : Text(snapshot.data['mobile']),
                                )
                              ]),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Mobile();
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          )
                        ],
                      ),
                      color: Colors.brown[50],
                      height: 50,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
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

  Future<String> updateBio({required String id, required String bio}) async {
    String res = 'some error occurs';
    try {
      await _firestore.collection('users').doc(id).update({'bio': bio});
      res = 'Bio Update Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
