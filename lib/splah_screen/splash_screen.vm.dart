import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SplashScreenVM extends GetxController with WidgetsBindingObserver {
  var appState = AppLifecycleState.resumed.obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appState.value = state;
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
}
