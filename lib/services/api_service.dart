import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_data.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] == '1';
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred during login: $e');
      return false;
    }
  }

  static Future<String> signUp(String name, String email, String password, String licenseKey) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/insert_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
          'licenseKey': licenseKey,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        print('Server responded with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return '0';
      }
    } catch (e) {
      print('Error occurred during sign up: $e');
      return '0';
    }
  }
}