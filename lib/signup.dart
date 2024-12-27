import 'package:finalflutter/complete_profile.dart';
import 'package:finalflutter/helpers/db_helper.dart';
import 'package:finalflutter/models/users.dart';
import 'package:finalflutter/services/api_users.dart';
import 'package:finalflutter/signin.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

bool _obsecureTextValue = true;
IconData _openCloseEyeIcon = Icons.remove_red_eye_outlined;
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();
bool _agreeTerms = false;
final Map<String, dynamic> _userData = {};

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Center(
                  child: Text(
                    'Fill your information below or register with your social account.',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            label: const Text(
                              'example@gmail.com',
                              style: TextStyle(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.1),
                                  strokeAlign: BorderSide.strokeAlignOutside),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obsecureTextValue,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _obsecureTextValue = !_obsecureTextValue;
                                _openCloseEyeIcon = _obsecureTextValue
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye;
                                setState(() {});
                              },
                              icon: Icon(_openCloseEyeIcon)),
                          label: const Text(
                            'Enter your password',
                            style: TextStyle(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.withOpacity(0.1),
                                strokeAlign: BorderSide.strokeAlignOutside),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is require';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: _obsecureTextValue,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                _obsecureTextValue = !_obsecureTextValue;
                                _openCloseEyeIcon = _obsecureTextValue
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye;
                                setState(() {});
                              },
                              icon: Icon(_openCloseEyeIcon)),
                          label: const Text(
                            'Confirm your password',
                            style: TextStyle(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.withOpacity(0.1),
                                strokeAlign: BorderSide.strokeAlignOutside),
                          ),
                        ),
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is required';
                          }
                          if (value != passwordController.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              activeColor: const Color(0xFF704F38),
                              value: _agreeTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeTerms = value!;
                                });
                              }),
                          RichText(
                            text: const TextSpan(
                                text: 'Agree with',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' Terms & Condition',
                                      style: TextStyle(
                                        color: Color(0xFF704F38),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline,
                                      ))
                                ]),
                          )
                        ],
                      ),
                      const SizedBox(height: 35),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!_agreeTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please agree to the Terns & Condition')));
                            } else {
                              String email = emailController.text.isNotEmpty
                                  ? emailController.text
                                  : '';
                              String password =
                                  passwordController.text.isNotEmpty
                                      ? passwordController.text
                                      : '';
                              // Now check if email or password are empty and show an error message if needed.
                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please fill in both fields')),
                                );
                                return;
                              }
                              Map<String, dynamic> userData = {
                                'code': '',
                                'name': '',
                                'address': '',
                                'role': 'user',
                                'gender': '',
                                'password': password,
                                'phone': '',
                                'email': email,
                                'status': '1',
                              };
                              try {
                                final userId =
                                    await ApiUser().addUser(userData);
                                print(userId);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompleteProfile(userId: userId)));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error $e')));
                              }
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFF704F38),
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 10,
                          )),
                          Text(
                            'Or sign in with',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          const Expanded(
                              child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 10,
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  )),
                              child: const Center(
                                child: Image(
                                  image: AssetImage('assets/logos/apple.png'),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ClipOval(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  )),
                              child: const Center(
                                child: Image(
                                  image: AssetImage('assets/logos/google.png'),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ClipOval(
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  )),
                              child: const Center(
                                child: Image(
                                  image:
                                      AssetImage('assets/logos/facebook.png'),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signin()));
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Color(0xFF704F38),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
