import 'package:get/get.dart';

import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/controller/user_points_controller.dart';


class MainViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<UserPointsController>(() => UserPointsController());
  }
}
