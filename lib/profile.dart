import 'package:finalflutter/edit_profile.dart';
import 'package:finalflutter/myorder.dart';
import 'package:finalflutter/payment_method.dart';
import 'package:finalflutter/privacy.dart';
import 'package:finalflutter/setting.dart';
import 'package:finalflutter/signin.dart';
import 'package:finalflutter/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomNavigatorMenu.dart';
import 'controllers/usercontroller.dart';

class Profile extends StatefulWidget {
  final Map<String, dynamic> userData;
  Profile({super.key, required this.userData});
  final UserController userController = Get.find<UserController>();

  @override
  State<Profile> createState() => _ProfileState();
}

Widget _buildListTile(IconData myIcon, String myText, VoidCallback onTap) {
  return ListTile(
    leading: Icon(myIcon, size: 32, color: Colors.brown),
    trailing: Icon(
      Icons.arrow_forward_ios,
      size: 20,
      color: Colors.grey.shade500,
    ),
    title: Text(
      myText,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
    ),
    onTap: onTap,
  );
}

final List<Map<String, dynamic>> _menuItems = [
  {
    'icon': Icons.person_outline,
    'title': 'Your profile',
  },
  {'icon': Icons.credit_card, 'title': 'Payment Methods'},
  {'icon': Icons.shopping_bag_outlined, 'title': 'My Orders'},
  {'icon': Icons.settings_outlined, 'title': 'Settings'},
  {'icon': Icons.help_outline, 'title': 'Help Center'},
  {'icon': Icons.lock_outline, 'title': 'Privacy Policy'},
  {'icon': Icons.group_outlined, 'title': 'Invite Friends'},
  {'icon': Icons.logout, 'title': 'Log out'},
];

class _ProfileState extends State<Profile> {
  final UserController userController = Get.find<UserController>();
  // Future<void> _logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('userId');
  //   Get.to(() => Signin());
  // }
  Future<void> _logout(BuildContext context) async {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 30),
                // Options
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFECECEC),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                          ),
                          onPressed: () async {
                            Navigator.pop(
                                context); // Close the bottom sheet first
                            // After closing the sheet, log out and navigate to the Signin screen
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('userId');
                            Get.offAll(
                                () => Signin()); // Navigate to Signin screen
                          },
                          child: Text(
                            'Yes, Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> navigationMap = {
      'Your profile': () => EditProfile(userData: widget.userData),
      'Payment Methods': () => PaymentMethod(),
      'My Orders': () => MyOrder(),
      'Settings': () => Setting(),
      'Help Center': () => (),
      'Privacy Policy': () => Privacy(),
      'Invite Friends': () => (),
      'Log out': _logout,
    };

    String name = widget.userData['name'];
    String imagePath = widget.userData['profile'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Center(
                    child: const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  width: 135,
                  height: 135,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('assets/profile/${imagePath}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Color(0xFF704F38),
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 4,
                              style: BorderStyle.solid,
                              color: Colors.white)),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return _buildListTile(
                    _menuItems[index]['icon'],
                    _menuItems[index]['title'],
                    () {
                      final String title = _menuItems[index]['title'];
                      final dynamic screenBuilder = navigationMap[title];

                      if (screenBuilder != null) {
                        if (title == 'Log out' && screenBuilder is Function) {
                          screenBuilder(context);
                        } else if (screenBuilder is Function) {
                          Get.to(screenBuilder());
                        }
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                itemCount: _menuItems.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
