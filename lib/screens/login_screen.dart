import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'emma_ai_screen.dart';
import '../services/api_service.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      final user = await ApiService.loginWithUser(email, password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EmmaAIScreen(
              licenseKey: user.licenseKey,
              name: user.name,
              email: user.email,
            ),
          ),
        );
      } else {
        showAuthDialog(context, '오류', '존재하지 않는 email 또는 비밀번호입니다.');
      }
    } catch (e) {
      showAuthDialog(context, '오류', '로그인 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scale = screenSize.width / 1920;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            height: screenSize.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: Text(
                      'Emma ai',
                      style: TextStyle(
                        color: Color(0xFF40C2FF),
                        fontSize: 60,
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(47 * scale)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20 * scale),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20 * scale),
                          Text(
                            'Emma Healthcare',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32 * scale,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10 * scale),
                          Text(
                            'Stomatitis AI Analyze System',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32 * scale,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 70 * scale),
                          buildAuthTextField(
                              'Email', Icons.email_outlined, scale, _emailController),
                          SizedBox(height: 10 * scale),
                          buildAuthTextField('Password', Icons.lock_outline, scale,
                              _passwordController,
                              isPassword: true),
                          SizedBox(height: 20 * scale),
                          buildAuthButton('Login', scale, _login),
                          SizedBox(height: 10 * scale),
                        Container(
                          width: 600 * scale,
                          height: 70 * scale,
                          child: ElevatedButton(
                            child: Text('Sign up', style: TextStyle(fontSize: 27 * scale, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6C6C6C),
                              side: BorderSide(
                                width: 4.0,
                                color: Color(0xFF40C2FF)
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17 * scale),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()),
                              );
                            },
                          ),
                        ),
                          SizedBox(height: 10 * scale),
                          Container(
                            width: 600 * scale,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // 비밀번호 재설정 로직 구현
                                },
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25 * scale,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 1,
                                  ),
                                ),
                              ),
                            ),
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
                    child: Image.asset(
                      'assets/logo/emmaLogo.png',
                      width: 200 * scale,  // scale 값을 적용하여 반응형으로 설정
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
