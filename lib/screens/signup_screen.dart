import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseKeyController = TextEditingController();

  void _showAlertDialog(String title, String message, {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String licenseKey = _licenseKeyController.text;

    try {
      String result = await ApiService.signUp(name, email, password, licenseKey);
      if (result == '1') {
        _showAlertDialog('성공', '회원가입이 완료되었습니다.', onConfirm: () {
          Navigator.pop(context);
        },);
      } else if (result == '2') {
        _showAlertDialog('오류', '이미 존재하는 이메일입니다.');
      } else if (result == '3') {
        _showAlertDialog('오류', '이미 존재하는 라이센스 키입니다.');
      } else {
        _showAlertDialog('오류', '회원가입에 실패했습니다.');
      }
    } catch (e) {
      _showAlertDialog('오류', '회원가입 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scale = screenSize.width / 1920;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                'emma ai',
                style: TextStyle(
                  color: Color(0xFF40C2FF),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 786 * scale,
              height: 621 * scale,
              decoration: BoxDecoration(
                color: Color(0xFF6C6C6C),
                borderRadius: BorderRadius.all(Radius.circular(47 * scale)),
              ),
              child: Padding(
                padding: EdgeInsets.all(20 * scale),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 50 * scale),
                    buildTextField('Name', Icons.person, scale, _nameController),
                    SizedBox(height: 10 * scale),
                    buildTextField('Email', Icons.email, scale, _emailController),
                    SizedBox(height: 10 * scale),
                    buildTextField('Password', Icons.lock, scale, _passwordController, isPassword: true),
                    SizedBox(height: 10 * scale),
                    buildTextField('License Key', Icons.vpn_key, scale, _licenseKeyController),
                    SizedBox(height: 20 * scale),
                    buildButton('Sign up', scale, _signUp),
                    SizedBox(height: 10 * scale),
                    TextButton(
                      child: Text('Login', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20 * scale, decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'emma\n',
                          style: TextStyle(
                            color: Color(0xFF40C2FF),
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      TextSpan(
                          text: 'healthcare',
                          style: TextStyle(
                            color: Color(0xFFB3B3B4),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          )
                      )
                    ]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildTextField(String hintText, IconData icon, double scale, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      width: 600 * scale,
      height: 70 * scale,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white, fontSize: 16 * scale),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.white, size: 24 * scale),
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16 * scale),
          filled: true,
          fillColor: Color(0xFF4A4A4A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10 * scale),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15 * scale, horizontal: 20 * scale),
        ),
      ),
    );
  }

  Widget buildButton(String text, double scale, VoidCallback onPressed) {
    return Container(
      width: 600 * scale,
      height: 70 * scale,
      child: ElevatedButton(
        child: Text(text, style: TextStyle(fontSize: 18 * scale)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF40C2FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10 * scale),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}