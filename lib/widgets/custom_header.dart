import 'package:flutter/material.dart';
import '../dialog/account_dialog.dart';
import '../dialog/settings_dialog.dart';

class CustomHeader extends StatefulWidget {
  final String? name;
  final String? email;

  const CustomHeader({
    Key? key,
    this.name,
    this.email,
  }) : super(key: key);

  @override
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: 100,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                'Emma Ai',
                style: TextStyle(
                  fontSize: 60 * (screenHeight / 1400),
                  color: Color(0xFF40C2FF),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildCustomIcon(Icons.settings, 50 * (screenHeight / 1400)),
              Spacer(),
              Text(
                'Professor ${widget.name ?? ""}',
                style: TextStyle(
                  fontSize: 22 * (screenHeight / 1400),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              _buildCustomIcon(Icons.account_circle, 50 * (screenHeight / 1400)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomIcon(IconData icon, double size) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        iconSize: size,
        splashRadius: 28,
        onPressed: () {
          if (icon == Icons.settings) {
            Navigator.of(context).push(
              DialogRoute(
                context: context,
                builder: (context) => SettingsDialog(),
              ),
            );
          } else if (icon == Icons.account_circle) {
            Navigator.of(context).push(
              DialogRoute(
                context: context,
                builder: (context) => AccountDialog(
                  name: widget.name,
                  email: widget.email,
                ),
              ),
            );
          }
        },
      ),
    );
  }
} 