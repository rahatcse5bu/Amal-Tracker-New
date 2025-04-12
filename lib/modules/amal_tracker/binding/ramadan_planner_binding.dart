import 'package:get/get.dart';
import 'package:amal_tracker/modules/amal_tracker/controller/amal_tracker_controller.dart';

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
