import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'emma_ai_screen.dart';
import '../models/user_data.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    users = await loadUsers();
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = users.firstWhere(
          (user) => user.email == email && user.password == password,
      orElse: () => User(email: '', password: '', name: ''),
    );

    if (user.email.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmmaAIScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
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
                    SizedBox(height: 20 * scale),
                    Text(
                      'Emma Healthcare',
                      style: TextStyle(color: Colors.white, fontSize: 32 * scale, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10 * scale),
                    Text(
                      'Stomatitis AI Analyze System',
                      style: TextStyle(color: Colors.white, fontSize: 32 * scale, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 70 * scale),
                    buildTextField('Email', Icons.email, scale, _emailController),
                    SizedBox(height: 10 * scale),
                    buildTextField('Password', Icons.lock, scale, _passwordController, isPassword: true),
                    SizedBox(height: 20 * scale),
                    buildButton('Login', scale, _login),
                    SizedBox(height: 10 * scale),
                    TextButton(
                      child: Text('Sign up', style: TextStyle(color: Colors.white, fontSize: 20 * scale, decoration: TextDecoration.underline)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
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