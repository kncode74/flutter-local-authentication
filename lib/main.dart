import 'package:biometrics_auth/local_auth.dart';
import 'package:biometrics_auth/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometrics Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primaryFixed: Colors.amberAccent.shade100,
          primary: Colors.brown,
          seedColor: Colors.black,
          // secondary: Colors.amberAccent.shade100,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
