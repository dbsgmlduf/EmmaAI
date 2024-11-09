import 'package:flutter/material.dart';

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          left: 50,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: 300,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logo/emmaLogo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '버전: 1.0.0',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('닫기'),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF40C2FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 