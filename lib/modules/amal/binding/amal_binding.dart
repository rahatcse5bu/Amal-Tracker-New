import 'package:get/get.dart';
import '../controller/amal_controller.dart';

class AmalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AmalController>(() => AmalController());
  }
}
