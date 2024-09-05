import 'package:biometrics_auth/local_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // สมัคร WidgetsBindingObserver
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // ยกเลิก WidgetsBindingObserver
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ตรวจสอบสถานะของแอป
    if (state == AppLifecycleState.paused) {
      print("แอปถูกย่อหน้าต่าง");
    } else if (state == AppLifecycleState.resumed) {
      print("แอปถูกเปิดขึ้นใหม่");
      // ทำงานเมื่อกลับเข้าแอปใหม่
    } else if (state == AppLifecycleState.inactive) {
      print(
          "แอปอยู่ในสถานะที่ไม่โต้ตอบกับผู้ใช้ได้ แต่ยังคงมองเห็นอยู่บางส่วน");
    } else if (state == AppLifecycleState.detached) {
      print("แอปทำงานใน Flutter engine แต่ไม่มีหน้าต่างการแสดงผล");
    } else if (state == AppLifecycleState.hidden) {
      print("แอปถูกซ่อนไว้และไม่แสดงผล");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lifecycle Example")),
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
            Text("ทดสอบ App Lifecycle"),
          ],
        ),
      ),
    );
  }
}
