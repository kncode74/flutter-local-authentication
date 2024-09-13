import 'package:flutter/material.dart';

class AuthenticationSwitch extends StatefulWidget {
  const AuthenticationSwitch({super.key});

  @override
  State<AuthenticationSwitch> createState() => _AuthenticationSwitchState();
}

class _AuthenticationSwitchState extends State<AuthenticationSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: true,
      activeColor: Colors.red,
      onChanged: (bool value) {
        setState(() {});
      },
    );
  }
}
