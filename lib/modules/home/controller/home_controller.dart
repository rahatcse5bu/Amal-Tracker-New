import 'package:get/get.dart';
import '../../../app/apis/api_helper.dart';

class HomeController extends GetxController {
  final ApiHelper apiHelper = Get.find<ApiHelper>();
  var currentQuoteType = 'hadith'.obs;
  var currentQuote = ''.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuote();
  }

  Future<void> loadQuote() async {
    isLoading(true);
    
    try {
      switch (currentQuoteType.value) {
        case 'hadith':
          final result = await apiHelper.fetchAjkerHadith();
          result.fold(
            (error) => currentQuote.value = 'Error loading hadith',
            (hadithList) => currentQuote.value = hadithList.first.bnText,
          );
          break;
          
        case 'ayat':
          final result = await apiHelper.fetchAjkerAyat();
          result.fold(
            (error) => currentQuote.value = 'Error loading ayat',
            (ayat) => currentQuote.value = ayat,
          );
          break;
          
        case 'salaf':
          final result = await apiHelper.fetchAjkerSalafQuote();
          result.fold(
            (error) => currentQuote.value = 'Error loading quote',
            (quote) => currentQuote.value = quote,
          );
          break;
      }
    } finally {
      isLoading(false);
    }
  }

  void cycleQuoteType() {
    switch (currentQuoteType.value) {
      case 'hadith':
        currentQuoteType.value = 'ayat';
        break;
      case 'ayat':
        currentQuoteType.value = 'salaf';
        break;
      case 'salaf':
        currentQuoteType.value = 'hadith';
        break;
    }
    loadQuote();
  }
}
