import 'dart:io';
import 'package:finalflutter/home.dart';
import 'package:finalflutter/services/api_users.dart';
import 'package:finalflutter/signin.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'bottomNavigatorMenu.dart';

class CompleteProfile extends StatefulWidget {
  final int userId;
  const CompleteProfile({super.key, required this.userId});
  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

String? filename;

class _CompleteProfileState extends State<CompleteProfile> {
  late final int userId;
  @override
  void initState() {
    super.initState();
    userId = widget.userId; // Initialize userId from the widget's parameter
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        filename = path.basename(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Camera and storage permissions are required')),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  List<String> _gender = ['Select Your Gender', 'Male', 'Female'];
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 2,
                        style: BorderStyle.solid,
                        color: const Color(0xFFE7E7E7))),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 33,
                      color: Color(0xFF45464D),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        'Don\'t worry, only you can see your personal data. No one else will be able to see it',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            ))
                        : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                            labelText: 'Enter Your Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Color(0xFF45464D),
                                ))),
                      ),
                      const SizedBox(height: 20),
                      const Text('Phone Number',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                      const SizedBox(
                        height: 10,
                      ),
                      IntlPhoneField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(),
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        initialCountryCode: 'KH',
                        onChanged: (phone) {
                          _phoneNumber = phone.completeNumber;
                        },
                      ),
                      const Text('Gender'),
                      const SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                              hintText: "Select your gender",
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Color(0xFFEDEDED)),
                                borderRadius: BorderRadius.circular(25),
                              )),
                          value: _selectedGender,
                          items: _gender.map((gender) {
                            return DropdownMenuItem(
                              child: Text(gender),
                              value: gender,
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                          child: Container(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF704F38)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String username = usernameController.text;
                                String phone = phoneController.text;
                                String gender = _selectedGender;
                                String imagePath = filename ?? 'no-image.png';
                                Map<String, dynamic> userData = {
                                  'name': username,
                                  'phone': phone,
                                  'gender': gender,
                                  'profile': imagePath,
                                };
                                await ApiUser().updateUser(userId, userData);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signin(),
                                    // NavigationMenu(userId: userId),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Complete Your Profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 22),
                            )),
                      ))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
