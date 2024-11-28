import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../widgets/auth_widgets.dart';
import '../services/patient_service.dart';

class AccountDialog extends StatefulWidget {
  final String? name;
  final String? email;

  const AccountDialog({
    Key? key,
    this.name,
    this.email,
  }) : super(key: key);

  @override
  _AccountDialogState createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  bool showPasswordFields = false;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          right: 50,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: _buildDialogContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserInfo(),
        if (showPasswordFields) 
          _buildPasswordFields()
        else
          _buildChangePasswordButton(),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "USER Information", 
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold
          )
        ),
        SizedBox(height: 10),
        Text(
          "Name: ${widget.name}", 
          style: TextStyle(color: Colors.white, fontSize: 22)
        ),
        Text(
          "Email: ${widget.email}", 
          style: TextStyle(color: Colors.white, fontSize: 22)
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        SizedBox(height: 16),
        buildAuthTextField('Old Password', Icons.lock, 0.5, 
            oldPasswordController, isPassword: true),
        SizedBox(height: 16),
        buildAuthTextField('New Password', Icons.lock, 0.5, 
            newPasswordController, isPassword: true),
        SizedBox(height: 16),
        buildAuthTextField('Confirm Password', Icons.lock, 0.5, 
            confirmPasswordController, isPassword: true),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _handlePasswordChange,
              child: Text("Confirm", 
                  style: TextStyle(color: Color(0xFF40C2FF),fontSize: 22)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", 
                  style: TextStyle(color: Colors.white,fontSize: 22)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChangePasswordButton() {
    return TextButton(
      onPressed: () => setState(() => showPasswordFields = true),
      child: Text("Change Password", 
          style: TextStyle(color: Color(0xFF40C2FF),fontSize: 22)),
    );
  }

  Widget _buildLogoutButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      },
      child: Text("Logout", 
          style: TextStyle(color: Color(0xFF40C2FF),fontSize: 22)),
    );
  }

  void _handlePasswordChange() async {
    if (newPasswordController.text == confirmPasswordController.text) {
      String message = await PatientService.changePassword(
        widget.email ?? '',
        oldPasswordController.text,
        newPasswordController.text,
      );
      Navigator.of(context).pop();
      _showResultDialog("비밀번호 변경", message);
    } else {
      _showResultDialog("오류", "새 비밀번호가 일치하지 않습니다.");
    }
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(title, style: TextStyle(color: Colors.white,fontSize: 22)),
          content: Text(message, style: TextStyle(color: Colors.white,fontSize: 22)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("확인", style: TextStyle(color: Color(0xFF40C2FF))),
            ),
          ],
        );
      },
    );
  }
} 