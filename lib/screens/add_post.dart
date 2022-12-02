import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vibrant_og/model/post.dart';
import 'package:vibrant_og/model/user.dart' as model;
import 'package:vibrant_og/providers/user_provider.dart';
import 'package:vibrant_og/services/storage_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Uint8List? postFile;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add a post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: postFile == null
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Choose image from'),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(),
                                  onPressed: () {
                                    selectImage(ImageSource.camera);
                                  },
                                  child: const Text('camera'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    selectImage(ImageSource.gallery);
                                  },
                                  child: const Text('Gallery'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 75,
                        ))
                    : Image(fit: BoxFit.fill, image: MemoryImage(postFile!)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                  controller: _titleController,
                  maxLength: 35,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                  )),
            ),
            Container(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (_descriptionController.text.isNotEmpty &&
                      _titleController.text.isNotEmpty &&
                      postFile != null) {
                    String res = await postPic(
                        uid: _auth.currentUser!.uid,
                        description: _descriptionController.text,
                        file: postFile!,
                        profilePic: user.profilePicUrl,
                        title: _titleController.text,
                        username: user.username);

                    print(res);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('Posted successfully'),
                      ),
                    );
                  } else {
                    print('some nulls found');
                  }
                },
                child: isLoading == true
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Post it!',
                        style: TextStyle(color: Colors.yellow),
                      ),
                style: ElevatedButton.styleFrom(primary: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectImage(ImageSource source) async {
    Uint8List im = await pickImage(source);
    setState(() {
      postFile = im;
    });
    Navigator.pop(context);
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

    print('No image selected');
  }

  Future<String> postPic(
      {required profilePic,
      required String uid,
      required username,
      required Uint8List file,
      required String title,
      required String description}) async {
    String res = 'some error occured';
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = Uuid().v1();
      Post post = Post(
          reports: [],
          likes: [],
          uid: uid,
          postId: postId,
          photoUrl: profilePic,
          description: description,
          username: username,
          postUrl: photoUrl,
          datePublished: formattedDate);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } on FirebaseAuthException catch (e) {
      res = e.message.toString();
    }
    return res;
  }
}
