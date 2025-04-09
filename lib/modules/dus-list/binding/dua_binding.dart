import 'package:get/get.dart';
import '../controller/dua_controller.dart';

class DuaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DuaController>(() => DuaController());
  }
}
