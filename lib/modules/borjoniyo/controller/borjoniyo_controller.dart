import 'package:get/get.dart';
import '../../../app/apis/api_helper.dart';
import '../models/borjoniyo_model.dart';

class BorjoniyoController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var borjoniyoList = <BorjoniyoModel>[].obs;
  var isLoading = true.obs;


  /// **Fetch Borjoniyo from API**
  void fetchBorjoniyoList() async {
    isLoading(true);
    final result = await _apiHelper.fetchBorjoniyo();

    result.fold(
      (error) {
        Get.snackbar("Error", error.message); // Show error
        isLoading(false);
      },
      (data) {
        borjoniyoList.value = data; // ✅ Set data
        isLoading(false);
      },
    );
  }


  @override
  void onInit() {
    fetchBorjoniyoList(); // Auto-fetch on init
    super.onInit();
  }
}
