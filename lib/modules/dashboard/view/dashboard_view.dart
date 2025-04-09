import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/app/common/storage/storage_controller.dart';
import 'package:ramadan_tracker/app/common/utils/ramadan_utils.dart';
import 'package:ramadan_tracker/modules/dashboard/widgets/leaderboard_widget.dart';
import 'package:ramadan_tracker/modules/dashboard/widgets/quote_widget.dart';
import 'package:ramadan_tracker/modules/dashboard/widgets/ramadan_days_list.dart';

import '../../../app/constants/app_color.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/translation/language_controller.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              LeaderboardWidget(),
              controller.AyatList.isNotEmpty
                  ? QuoteWidget(
                      title: TranslationKeys.selectedVerses.tr,
                      text: controller.AyatList.first.enText,
                      type: 'ajker_ayat')
                  : CupertinoActivityIndicator(
                      color: AppColors.primary,
                    ),
              controller.HadithList.isNotEmpty
                  ? QuoteWidget(
                      title: "নির্বাচিত হাদিস",
                      // text: controller.ajkerHadith.value,
                      text: controller.HadithList.first.enText,
                      type: 'ajker_hadith')
                  : CupertinoActivityIndicator(
                      color: AppColors.primary,
                    ),
              controller.salafQuotes.isNotEmpty
                  ? QuoteWidget(
                      title: "সালাফদের বক্তব্য",
                      // text: controller.ajkerSalafQuote.value,
                      text: controller.salafQuotes.first.enText,
                      type: 'salaf_quote')
                  : CupertinoActivityIndicator(
                      color: AppColors.primary,
                    ),
              // Text("${TranslationKeys.selectedVerses.tr}"),
              RamadanDaysList(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildLanguageItem(
  BuildContext context, {
  required String languageCode,
  required String label,
}) {
  final controller = Get.find<LanguageController>();

  return Obx(() {
    final bool isSelected = controller.appLocale?.languageCode == languageCode;

    return InkWell(
      onTap: () => controller.changeLanguage(
          languageCode, languageCode == 'bn' ? 'BD' : 'US'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.green : Colors.black,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
          ],
        ),
      ),
    );
  });
}
