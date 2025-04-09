import 'package:get/get.dart';

import '../../../modules/dashboard/controller/dashboard_controller.dart';
import '../../apis/api_helper.dart';
import '../../apis/api_helper_implementation.dart';
import '../../common/controller/app_controller.dart';
import '../../translation/language_controller.dart';
import '../controller/app_update_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController());
   
    // Ensure only one instance of ApiHelperImpl is created and globally accessible.
    Get.lazyPut<ApiHelper>(() => ApiHelperImpl());
     Get.lazyPut<AppUpdateController>(() => AppUpdateController());
    Get.lazyPut<AppController>(() => AppController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => LanguageController());
  }
}
