import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ramadan_tracker/modules/dus-list/models/dua_model.dart';
import '../../../app/constants/app_color.dart';
import 'package:get/get.dart';
import '../../../app/translation/language_controller.dart';
import '../controller/dua_controller.dart';

class DuaCardWidget extends GetWidget<DuaController> {
final DuaModel dua;

  const DuaCardWidget({super.key,required this.dua});

  @override
  Widget build(BuildContext context) {

    final languageController = Get.find<LanguageController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CupertinoActivityIndicator(color: AppColors.primary),
        );
      }

      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               dua.title,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary),
              ),
              SizedBox(height: 8.h),
              Text(
                dua.arabic,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ExpandableText(
                languageController.appLocale?.languageCode == 'bn'
                    ? dua.bangla
                    : dua.title, // Use title as fallback
                expandText: languageController.appLocale?.languageCode == 'bn'
                    ? 'আরো দেখুন'
                    : 'Show more',
                collapseText:
                    languageController.appLocale?.languageCode == 'bn'
                        ? 'কম দেখুন'
                        : 'Show less',
                maxLines: 170,
                linkColor: AppColors.primary,
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      );
    });
  }
}
