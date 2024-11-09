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
    return Container(
      height: 100,
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildCustomIcon(Icons.settings, 50),
          SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Text(
                'emma ai',
                style: TextStyle(
                  fontSize: 61,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Text(
            'Professor ${widget.name ?? ""}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
          _buildCustomIcon(Icons.account_circle, 50),
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
            print("hell");
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