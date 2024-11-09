import 'package:flutter/material.dart';

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/logo/emmaLogo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          child: Center(
            child: Text('버전: 1.0.0'),
          ),
        ),
      ],
    );
  }
} 