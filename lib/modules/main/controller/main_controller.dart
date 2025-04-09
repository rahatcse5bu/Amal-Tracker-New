import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/apis/api_helper.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/translation/translation_keys.dart';

class MainController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = true.obs;



  @override
  void onInit() {
    super.onInit();
  }

  void openMoreBottomSheet() {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16), // ✅ Add padding for better UX
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Wrap( // ✅ Auto-wrap if items exceed screen width
        spacing: 8.w, // ✅ Horizontal spacing
        runSpacing: 8.h, // ✅ Vertical spacing
        alignment: WrapAlignment.center, // ✅ Center items
        children: [
          _buildBottomSheetItem(
              TranslationKeys.ramadaneKoroniyo.tr,Routes.koroniyo, Icons.check_circle),
          _buildBottomSheetItem(TranslationKeys.ramadaneBorjoniyo.tr,Routes.borjoniyo, Icons.cancel),
          _buildBottomSheetItem(TranslationKeys.duas.tr,Routes.duaList, Icons.book),
        ],
      ),
    ),
    enableDrag: true,
  );
}

/// **Build Bottom Sheet Item**
Widget _buildBottomSheetItem(String title,String slug, IconData icon) {
  return GestureDetector(
    onTap: () {
      Get.back(); // ✅ Close bottom sheet before navigating
      _navigateTo(slug); // ✅ Navigate based on title
    },
    child: Column(
      children: [
        Card( // ✅ Use Card for better UI
        color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(icon, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(title, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// **Handle Navigation Based on Title**
// void _navigateTo(String slug) {
//   if (slug == TranslationKeys.koroniyo.tr) {
//     Get.toNamed(slug);
//   } else if (slug == TranslationKeys.borjoniyo.tr) {
//     Get.toNamed(slug);
//   } else if (slug == TranslationKeys.duas.tr) {
//     Get.toNamed(slug);
//   }
// }
void _navigateTo(String slug) {

    Get.toNamed(slug);

}

}
