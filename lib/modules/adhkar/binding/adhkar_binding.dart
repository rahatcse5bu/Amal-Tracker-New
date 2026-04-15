import 'package:get/get.dart';
import '../controller/adhkar_controller.dart';

class AdhkarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdhkarController>(() => AdhkarController());
  }
}
