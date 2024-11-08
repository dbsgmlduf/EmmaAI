import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildCustomIcon(context, Icons.settings, 50),
          SizedBox(width: 10),
          _buildCustomIcon(context, Icons.help_outline, 50),
          Expanded(
            child: Center(
              child: Text(
                'emma ai',
                style: TextStyle(
                  fontSize: 61,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _buildCustomIcon(context, Icons.account_circle, 50),
          SizedBox(width: 10),
          _buildCustomIcon(context, Icons.more_vert, 40, showMenu: true),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildCustomIcon(BuildContext context, IconData icon, double size, {bool showMenu = false}) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      iconSize: size,
      onPressed: () {
        if (showMenu) {
          _showPopupMenu(context);
        } else if (icon == Icons.help_outline) {
          print('도움말 버튼이 클릭되었습니다.');
        } else if (icon == Icons.settings) {
          print('설정 버튼이 클릭되었습니다.');
        } else if (icon == Icons.account_circle) {
          print('계정 버튼이 클릭되었습니다.');
        }
      },
    );
  }

  void _showPopupMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(1000, 0, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout, color: Color(0xFF40C2FF)),
            title: Text('로그아웃', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ),
      ],
    );
  }
} 