import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class User {
  final String email;
  final String password;
  final String name;

  User({required this.email, required this.password, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      name: json['name']
    );
  }
}

Future<List<User>> loadUsers() async {
  String jsonString = await rootBundle.loadString('assets/dummy_users.json');
  final jsonResponse = json.decode(jsonString);
  return (jsonResponse['users'] as List).map((user) => User.fromJson(user)).toList();
}