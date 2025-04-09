import 'package:get/get.dart';
import '../../../app/apis/api_helper.dart';
import '../models/koroniyo_model.dart';

class KoroniyoController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var koroniyoList = <KoroniyoModel>[].obs;
  var isLoading = true.obs;


  /// **Fetch Borjoniyo from API**
  void fetchKoroniyoList() async {
    isLoading(true);
    final result = await _apiHelper.fetchKoroniyo();

    result.fold(
      (error) {
        Get.snackbar("Error", error.message); // Show error
        isLoading(false);
      },
      (data) {
        koroniyoList.value = data; // ✅ Set data
        isLoading(false);
      },
    );
  }


  @override
  void onInit() {
    fetchKoroniyoList(); // Auto-fetch on init
    super.onInit();
  }
}
