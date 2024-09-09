import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth extends StatefulWidget {
  const LocalAuth({super.key});

  @override
  State<LocalAuth> createState() => _LocalAuthState();
}

class _LocalAuthState extends State<LocalAuth> with WidgetsBindingObserver {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _supportState = isSupported;
      });
    });
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
    }
  }

  //Step 1: check device have Biometric and supported
  Future<bool> _canAuthenticate() async {
    final bool haveBiometric = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        haveBiometric && await auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<void> _getBiometricsType() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print('List of Biometrics : $availableBiometrics');
    //[wrong,
    // weak,
    // face,
    // fingerprint]
    if (!mounted) return;
  }

  Future<void> _authenticate() async {
    try {
      auth
          .authenticate(
        localizedReason: 'Please authenticate to access your bank account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      )
          .then((bool isAuth) {
        if (isAuth) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication Complete')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication Not Matching ')),
          );
        }
      });
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication is error : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter biometrics',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent.shade100,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_supportState)
              const Text('This device is supported')
            else
              const Text('This device is not  supported'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _biometricsTypeContent(),
                const SizedBox(width: 30),
                _authenContent(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _biometricsTypeContent() {
    return ElevatedButton(
      onPressed: () {
        _getBiometricsType();
      },
      child: const Text('Authen type'),
    );
  }

  Widget _authenContent() {
    return ElevatedButton(
      onPressed: () async {
        bool canAuthenticate = await _canAuthenticate();
        if (!canAuthenticate) return;
        _authenticate();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent.shade100),
      child: const Text(
        'authenticate',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
