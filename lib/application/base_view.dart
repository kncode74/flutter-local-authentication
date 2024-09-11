import 'package:biometrics_auth/application/base_vm.dart';
import 'package:get/get.dart';

import 'life_cycle_observer.dart';

abstract class BaseView<Controller extends BaseVM > extends GetView<Controller>implements LifeCycleListener{

}