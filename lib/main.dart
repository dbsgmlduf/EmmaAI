import 'package:flutter/material.dart';
import 'screens/emma_ai_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emma AI',
      theme: AppTheme.darkTheme,
      home: EmmaAIScreen(),
    );
  }
}