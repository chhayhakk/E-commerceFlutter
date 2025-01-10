import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalflutter/models/users.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';

class ApiUser {
  Future<List<Users>> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://18.143.178.80/api/users'));
      if (response.statusCode == 200) {
        final List userJson = json.decode(response.body);
        print(userJson);
        return userJson.map((user) => Users.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('http://18.143.178.80/api/users'),
        body: userData,
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print('Response data: $data');
        if (data.containsKey('id')) {
          return data['id'];
        } else {
          throw Exception('No ID returned from the server.');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Failed to add user: ${errorData['message']}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('http://18.143.178.80/api/complete_profile/$userId'),
        body: json.encode(userData),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        final data = json.decode(response.body);
        print('User updated successfully: $data');
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('User updated successfully: $data');
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Failed to update user: ${errorData['message']}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
