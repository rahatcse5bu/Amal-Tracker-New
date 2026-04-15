import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../../../app/constants/app_color.dart';
import '../../../app/translation/language_controller.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/dashboard_controller.dart';

class QuoteWidget extends GetWidget<DashboardController> {
  final String title;
  final String text;
  final String? type;

  const QuoteWidget({required this.title, required this.text, this.type});

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'ajker_ayat':
        return Icons.auto_awesome;
      case 'ajker_hadith':
        return Icons.menu_book;
      case 'salaf_quote':
        return Icons.person;
      default:
        return Icons.format_quote;
    }
  }

  Color _getColorForType(String? type) {
    switch (type) {
      case 'ajker_ayat':
        return const Color(0xFF4CAF50);
      case 'ajker_hadith':
        return const Color(0xFF2196F3);
      case 'salaf_quote':
        return const Color(0xFFFF9800);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Obx(() {
      final languageCode = languageController.appLocale?.languageCode ?? 'en';

      // Dynamic displayTitle update
      String displayTitle;
      switch (type) {
        case 'ajker_ayat':
          displayTitle = TranslationKeys.selectedVerses.tr;
          break;
        case 'ajker_hadith':
          displayTitle = TranslationKeys.selectedHadith.tr;
          break;
        case 'salaf_quote':
          displayTitle = TranslationKeys.salafQuotes.tr;
          break;
        default:
          displayTitle = title;
      }

      // Dynamic displayText update
      String displayText;
      switch (type) {
        case 'ajker_ayat':
          displayText = controller.AyatList.isNotEmpty
              ? (languageCode == 'bn'
                  ? controller.AyatList.first.bnText
                  : controller.AyatList.first.enText)
              : 'আয়াত পাওয়া যায়নি';
          break;
        case 'ajker_hadith':
          displayText = controller.HadithList.isNotEmpty
              ? (languageCode == 'bn'
                  ? controller.HadithList.first.bnText
                  : controller.HadithList.first.enText)
              : 'হাদিস পাওয়া যায়নি';
          break;
        case 'salaf_quote':
          displayText = controller.salafQuotes.isNotEmpty
              ? (languageCode == 'bn'
                  ? controller.salafQuotes.first.bnText
                  : controller.salafQuotes.first.enText)
              : 'উদ্ধৃতি পাওয়া যায়নি';
          break;
        default:
          displayText = text;
      }

      final accentColor = _getColorForType(type);
      final iconData = _getIconForType(type);

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Icon and Title
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          iconData,
                          color: accentColor,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayTitle,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'আজকের অনুশীলন',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'নতুন',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey[200],
                  ),
                  SizedBox(height: 16.h),

                  // Content
                  if (controller.isLoading.value)
                    Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  else
                    ExpandableText(
                      displayText,
                      expandText:
                          languageCode == 'bn' ? 'আরো দেখুন' : 'Show more',
                      collapseText:
                          languageCode == 'bn' ? 'কম দেখুন' : 'show less',
                      maxLines: 4,
                      linkColor: accentColor,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),
                  SizedBox(height: 12.h),

                  // Footer action
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_outline, size: 16.sp),
                    label: Text('সংরক্ষণ করুন'),
                    style: TextButton.styleFrom(
                      foregroundColor: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
