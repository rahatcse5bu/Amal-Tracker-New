import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../Data/data.dart';
import '../storage/storage_controller.dart';

class GoodAfternoonController extends GetxController {
  final int ramadanDay;

  GoodAfternoonController(this.ramadanDay);

  final List<TextEditingController> controllers = List.generate(
    Good_Afternoon_Items_inputs.length,
    (index) => TextEditingController(),
  );

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    for (int i = 0; i < controllers.length; i++) {
      String? savedValue = await StorageHelper.getGoodAfternoonItem(ramadanDay, i);
      controllers[i].text = savedValue ?? "";
    }
    update(); // Refresh UI
  }

  Future<void> saveData(int index) async {
    await StorageHelper.setGoodAfternoonItem(ramadanDay, index, controllers[index].text);
    Get.snackbar("সফলতা", "আপনার তথ্য সংরক্ষণ করা হয়েছে", snackPosition: SnackPosition.BOTTOM);
  }
}
