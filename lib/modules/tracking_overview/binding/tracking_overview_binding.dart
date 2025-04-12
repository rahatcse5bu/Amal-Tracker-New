import 'package:get/get.dart';
import '../controller/tracking_overview_controller.dart';

class TrackingOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrackingOverviewController());
  }
}
