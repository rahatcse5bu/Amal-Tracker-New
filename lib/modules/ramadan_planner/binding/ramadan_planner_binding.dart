import 'package:get/get.dart';
import 'package:ramadan_tracker/modules/ramadan_planner/controller/ramadan_planner_controller.dart';

import '../../../app/common/controller/nav_controller.dart';
import '../controller/quick_jump_section_controller.dart';

class RamadanPlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuickJumpSectionController>(() => QuickJumpSectionController());
    Get.lazyPut<RamadanPlannerController>(() => RamadanPlannerController());
    Get.lazyPut<NavController>(() => NavController());
  }
}
