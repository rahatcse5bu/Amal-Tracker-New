import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/translation/translation_keys.dart';

class MainController extends GetxController {
  var isLoading = true.obs;



  @override
  void onInit() {
    super.onInit();
  }

  void openMoreBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              // Header Section
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(20.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More Options',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Explore Ramadan activities',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    _buildBottomSheetItem(
                      title: TranslationKeys.ramadaneKoroniyo.tr,
                      slug: Routes.koroniyo,
                      icon: Icons.check_circle_rounded,
                      description: 'Admirable deeds',
                      bgGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.teal.withOpacity(0.05),
                        ],
                      ),
                      iconColor: Colors.green,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetItem(
                      title: TranslationKeys.ramadaneBorjoniyo.tr,
                      slug: Routes.borjoniyo,
                      icon: Icons.block_rounded,
                      description: 'Restricted items',
                      bgGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red.withOpacity(0.1),
                          Colors.orange.withOpacity(0.05),
                        ],
                      ),
                      iconColor: Colors.red,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetItem(
                      title: TranslationKeys.duas.tr,
                      slug: Routes.duaList,
                      icon: Icons.menu_book_rounded,
                      description: 'Daily prayers',
                      bgGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.05),
                        ],
                      ),
                      iconColor: AppColors.primary,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetItem(
                      title: 'আধকার (জিকির)',
                      slug: Routes.adhkar,
                      icon: Icons.favorite_rounded,
                      description: 'ইসলামিক স্মরণ',
                      bgGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red.withOpacity(0.1),
                          Colors.pink.withOpacity(0.05),
                        ],
                      ),
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      enableDrag: true,
      isScrollControlled: true,
    );
  }

  /// **Build Enhanced Bottom Sheet Item**
  Widget _buildBottomSheetItem({
    required String title,
    required String slug,
    required IconData icon,
    required String description,
    required LinearGradient bgGradient,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back(); // Close bottom sheet before navigating
        _navigateTo(slug);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: bgGradient,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_rounded,
                  color: iconColor.withOpacity(0.6),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
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
