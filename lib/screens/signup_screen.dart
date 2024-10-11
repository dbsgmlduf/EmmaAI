import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/auth_widgets.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseKeyController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String licenseKey = _licenseKeyController.text;

      try {
        String result = await ApiService.signUp(name, email, password, licenseKey);
        if (result == '1') {
          showAuthDialog(context,'성공', '회원가입이 완료되었습니다.', onConfirm: () {
            Navigator.pop(context);
          });
        } else if (result == '2') {
          showAuthDialog(context,'오류', '이미 존재하는 이메일입니다.');
        } else if (result == '3') {
          showAuthDialog(context,'오류', '이미 존재하는 라이센스 키입니다.');
        } else {
          showAuthDialog(context,'오류', '회원가입에 실패했습니다.');
        }
      } catch (e) {
        showAuthDialog(context,'오류', '회원가입 중 오류가 발생했습니다: $e');
      }
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
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(20 * scale),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 50 * scale),
                      buildAuthTextField('Name', Icons.person, scale, _nameController),
                      SizedBox(height: 10 * scale),
                      buildAuthTextField('Email', Icons.email, scale, _emailController, validator: _validateEmail),
                      SizedBox(height: 10 * scale),
                      buildAuthTextField('Password', Icons.lock, scale, _passwordController, isPassword: true),
                      SizedBox(height: 10 * scale),
                      buildAuthTextField('License Key', Icons.vpn_key, scale, _licenseKeyController),
                      SizedBox(height: 20 * scale),
                      buildAuthButton('Sign up', scale, _signUp),
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
}