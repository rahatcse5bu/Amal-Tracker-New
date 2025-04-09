import 'dart:developer';

import 'package:get/get.dart';
import 'package:ramadan_tracker/modules/dus-list/models/dua_model.dart';
import '../../../app/apis/api_helper.dart';

class DuaController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = true.obs;
  var DuaList = <DuaModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDua();
  }

  

   Future<void> fetchDua() async {
    final result = await _apiHelper.fetchDua();
    result.fold((error) => null, (dua) => DuaList.value = dua);
    isLoading.value=false;
    log("ajker ayat: " + DuaList.first.arabic);
  }

}
