import 'package:get/get.dart';
import '../controller/borjoniyo_controller.dart';

class BorjoniyoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BorjoniyoController>(() => BorjoniyoController());
  }
}
