import 'package:get/get.dart';

import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/controller/user_points_controller.dart';
import '../../home/binding/home_binding.dart';
import '../../amal/binding/amal_binding.dart';
import '../../adhkar/binding/adhkar_binding.dart';
import '../controller/main_controller.dart';


class MainViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<UserPointsController>(() => UserPointsController());
    
    // Include home binding for HomeView
    HomeBinding().dependencies();
    
    // Include amal binding for AmalView
    AmalBinding().dependencies();
    
    // Include adhkar binding for AdhkarView
    AdhkarBinding().dependencies();
  }
}
