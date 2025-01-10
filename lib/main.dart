import 'package:finalflutter/bottomNavigatorMenu.dart';
import 'package:finalflutter/complete_profile.dart';
import 'package:finalflutter/edit_profile.dart';
import 'package:finalflutter/home.dart';
import 'package:finalflutter/product_detail.dart';
import 'package:finalflutter/profile.dart';
import 'package:finalflutter/signin.dart';
import 'package:finalflutter/signup.dart';
import 'package:finalflutter/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/usercontroller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data != 0) {
            return NavigationMenu(userId: snapshot.data!);
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}

Future<int> _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  return userId ?? 0;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final UserController userController = Get.put(UserController());
  await Future.delayed(Duration(seconds: 2));
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}
