import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../widgets/auth_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseKeyController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

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

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String licenseKey = _licenseKeyController.text;
      String newPassword = _newPasswordController.text;

      try {
        String message = await PatientService.resetPassword(
          email,
          licenseKey,
          newPassword,
        );
        
        if (message == '1') {
          showAuthDialog(context, '성공', '비밀번호가 재설정되었습니다.', onConfirm: () {
            Navigator.pop(context);
          });
        } else if (message == '2') {
          showAuthDialog(context, '오류', '존재하지 않는 이메일입니다.');
        } else if (message == '3') {
          showAuthDialog(context, '오류', '라이센스 키가 일치하지 않습니다.');
        } else {
          showAuthDialog(context, '오류', '비밀번호 재설정에 실패했습니다.');
        }
      } catch (e) {
        showAuthDialog(context, '오류', '비밀번호 재설정 중 오류가 발생했습니다: $e');
      }
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
                    height: 620 * scale,
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
                            SizedBox(height: 20 * scale),
                            Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32 * scale,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 50 * scale),
                            buildAuthTextField(
                              'Email',
                              Icons.email_outlined,
                              scale,
                              _emailController,
                              validator: _validateEmail,
                            ),
                            SizedBox(height: 20 * scale),
                            buildAuthTextField(
                              'License Key',
                              Icons.key_outlined,
                              scale,
                              _licenseKeyController,
                            ),
                            SizedBox(height: 20 * scale),
                            buildAuthTextField(
                              'New Password',
                              Icons.lock_outline,
                              scale,
                              _newPasswordController,
                              isPassword: true,
                            ),
                            SizedBox(height: 50 * scale),
                            buildAuthButton('Reset Password', scale, _resetPassword),
                            SizedBox(height: 20 * scale),
                            Container(
                              width: 600 * scale,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Login',
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
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Image.asset(
                      'assets/logo/emmaLogo.png',
                      width: 200 * scale,
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