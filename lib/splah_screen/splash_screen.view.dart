import 'package:biometrics_auth/local_auth.dart';
import 'package:biometrics_auth/splah_screen/splash_screen.vm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final lifecycleController = Get.put(SplashScreenVM());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lifecycle Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LocalAuth()));
              },
              child: Text('Authentication local'),
            ),
            Text("Lifecycle Example"),
            Obx(() {
              return Text(
                  'Current state: ${lifecycleController.appState.value}');
            }),
          ],
        ),
      ),
    );
  }
}
