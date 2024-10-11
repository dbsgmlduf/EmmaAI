import 'package:flutter/material.dart';

Widget buildAuthTextField(String hintText, IconData icon, double scale, TextEditingController controller, {bool isPassword = false, String? Function(String?)? validator}) {
  return Container(
    width: 600 * scale,
    height: 70 * scale,
    child: TextFormField(
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
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return '$hintText를 입력해주세요';
        }
        return null;
      },
    ),
  );
}

Widget buildAuthButton(String text, double scale, VoidCallback onPressed) {
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

void showAuthDialog(BuildContext context, String title, String message, {VoidCallback? onConfirm}) {
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