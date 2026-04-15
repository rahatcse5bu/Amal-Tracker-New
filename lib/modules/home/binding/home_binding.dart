import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../prayer_times/binding/prayer_times_binding.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    PrayerTimesBinding().dependencies();
  }
}
