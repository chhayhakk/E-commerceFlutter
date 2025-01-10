import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfile({super.key, required this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? filename;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        filename = path.basename(pickedFile.path);
      });
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text('Camera and storage permissions are required')),
      // );
    }
  }

  void showModal() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    _pickImage(ImageSource.camera);
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.camera,
                        size: 32,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Use Camera',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
              CupertinoActionSheetAction(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                    Get.back();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.image,
                        size: 32,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Select profile picture',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.userData['name'];
    String phone = widget.userData['phone'];
    String email = widget.userData['email'];
    String gender = widget.userData['gender'];
    String imagePath = widget.userData['profile'];
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 32,
                          color: Colors.black,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text('Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile picture',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: showModal,
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.brown,
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                child: ClipOval(
                    child: _imageFile == null
                        ? Image.asset(
                            'assets/profile/${imagePath}',
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey.shade500,
              thickness: 0.6,
              indent: 10,
              endIndent: 10,
            ),
            Text(
              'Personal Info',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(Icons.person, size: 32, color: Colors.brown),
              title: Text(name),
              trailing: IconButton(
                  onPressed: () {}, icon: Icon(Icons.edit, size: 22)),
            ),
            ListTile(
              leading: Icon(Icons.phone, size: 32, color: Colors.brown),
              title: Text(phone),
              trailing: IconButton(
                  onPressed: () {}, icon: Icon(Icons.edit, size: 22)),
            ),
            ListTile(
              leading: Icon(Icons.email, size: 32, color: Colors.brown),
              title: Text(email),
              trailing: IconButton(
                  onPressed: () {}, icon: Icon(Icons.edit, size: 22)),
            ),
            ListTile(
              leading: Icon(Icons.transgender, size: 32, color: Colors.brown),
              title: Text(gender),
              trailing: IconButton(
                  onPressed: () {}, icon: Icon(Icons.edit, size: 22)),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Save Change',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
