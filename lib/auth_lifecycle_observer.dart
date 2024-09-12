import 'package:flutter/cupertino.dart';

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
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
