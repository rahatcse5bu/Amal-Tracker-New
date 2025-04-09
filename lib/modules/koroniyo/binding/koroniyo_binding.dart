import 'package:get/get.dart';
import '../controller/koroniyo_controller.dart';

class KoroniyoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KoroniyoController>(() => KoroniyoController());
  }
}
