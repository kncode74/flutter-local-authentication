import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthLifecycleObserver extends WidgetsBindingObserver {
  bool _isAuth = false;

  init() {
    WidgetsBinding.instance.addObserver(this);
    _triggerLifecycle();
  }

  _triggerLifecycle() {
    if (_isAuth) return;
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  Future<bool> checkAuthenticate() async {
    final bool haveBiometric = await LocalAuthentication().canCheckBiometrics;
    final bool deviceSupport = await LocalAuthentication().isDeviceSupported();
    final List<BiometricType> haveBiometricType =
        await LocalAuthentication().getAvailableBiometrics();
    return haveBiometric && deviceSupport && haveBiometricType.isNotEmpty;
  }

  Future<bool> _requestAuthentication() async {
    try {
      bool authenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Please authenticate to access your bank account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      return authenticated;
    } catch (e) {
      rethrow;
    }
  }

  _authentication() async {
    if (_isAuth) return;
    try {} catch (e) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_isAuth) return;
        _authentication();
        print('App is resumed');
        break;
      case AppLifecycleState.inactive:
        print('App is inactive');
        break;
      case AppLifecycleState.paused:
        print('App is paused');
        break;
      case AppLifecycleState.detached:
        print('App is detached');
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
    super.didChangeAppLifecycleState(state);
  }
}
