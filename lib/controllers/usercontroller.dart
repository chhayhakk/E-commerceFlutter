import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../signin.dart';

class UserController extends GetxController {
  var userData = Rx<Map<String, dynamic>?>(null);

  Future<void> fetchUserData(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('http://18.143.178.80/api/get_user/$userId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userData.value = data;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
