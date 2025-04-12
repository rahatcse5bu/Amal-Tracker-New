import 'package:get/get.dart';
import '../controller/prayer_times_controller.dart';

class PrayerTimesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrayerTimesController());
  }
}
