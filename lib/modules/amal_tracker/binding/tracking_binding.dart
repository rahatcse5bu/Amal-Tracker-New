import 'package:get/get.dart';
import '../controller/tracking_controller.dart';

class TrackingBinding extends Bindings {
  final int ramadanDay;
  final String slug;
  final String type;

  TrackingBinding({required this.ramadanDay, required this.slug, required this.type});

  @override
  void dependencies() {
    Get.put<TrackingController>(
      TrackingController(ramadanDay: ramadanDay, slug: slug, type: type),
    );
  }
}
