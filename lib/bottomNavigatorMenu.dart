import 'dart:convert';

import 'package:finalflutter/controllers/productcontroller.dart';
import 'package:finalflutter/home.dart';
import 'package:finalflutter/mycart.dart';
import 'package:finalflutter/profile.dart';
import 'package:finalflutter/controllers/usercontroller.dart';
import 'package:finalflutter/signin.dart';
import 'package:finalflutter/signup.dart';
import 'package:finalflutter/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class NavigationMenu extends StatefulWidget {
  final int userId;
  const NavigationMenu({super.key, required this.userId});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final UserController userController = Get.put(UserController());
  final ProductController productController = Get.put(ProductController());
  int _bottomSelectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    userController.fetchUserData(widget.userId);
    productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _bottomSelectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xFF704F38),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 22,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    size: 22,
                  ),
                  label: 'Favorite'),
              BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.bagShopping,
                    size: 22,
                  ),
                  label: 'Shop'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                    size: 22,
                  ),
                  label: 'Profile')
            ]),
        body: Obx(() => userController.userData.value == null ||
                productController.products.value == null
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.brown,
              ))
            : IndexedStack(
                index: _bottomSelectedIndex,
                children: [
                  Home(userData: userController.userData.value!),
                  const WelcomeScreen(),
                  const WelcomeScreen(),
                  Profile(userData: userController.userData.value!),
                ],
              )));
  }
}
