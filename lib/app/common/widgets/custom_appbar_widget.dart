import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../modules/dashboard/controller/dashboard_controller.dart';
import '../../../modules/dashboard/controller/user_points_controller.dart';
import '../../../modules/amal_tracker/controller/quick_jump_section_controller.dart';
import '../../../modules/amal_tracker/controller/amal_tracker_controller.dart';
import '../../../modules/amal_tracker/controller/tracking_controller.dart';
import '../../constants/app_color.dart';
import '../../routes/app_pages.dart';
import '../../translation/language_controller.dart';
import '../../translation/translation_keys.dart';
import '../controller/app_controller.dart';
import '../storage/storage_controller.dart';
import '../utils/ramadan_utils.dart';

class CustomAppBar {
  // Static method to create a custom app bar
  static PreferredSizeWidget appBar({
    required String title,
    bool centerTitle = true,
    Color? backgroundColor,
    Color? titleColor,
    String? name,
    List<Widget>? actions,
    IconData? leadingIcon,
    Widget? leadingWidget,
    double? leadingWidth,
    String? profilePicture,
    VoidCallback? onLeadingPressed,
  }) {
    // final AppController appController = Utils.getAppController();
    final DashboardController dashboardController = Get.find();

    return AppBar(
      scrolledUnderElevation: 0,
      leadingWidth: 60.w,
      elevation: 2,
      toolbarHeight: 70.h,
      backgroundColor: backgroundColor ?? AppColors.primary,
      automaticallyImplyLeading: false,
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(leadingIcon, color: Colors.white, size: 24.sp),
              onPressed: onLeadingPressed ?? () => Get.back(),
            )
          : null,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Points Display (Left-Center)
            Expanded(
              child: Obx(() => dashboardController.isLoading.value
                  ? CupertinoActivityIndicator(color: Colors.white)
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18.sp),
                          SizedBox(width: 6.w),
                          Text(
                            "${dashboardController.totalPoints.value}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            " pts",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    )),
            ),
            SizedBox(width: 12.w),
            // Rank Display (Center-Right)
            Obx(() => dashboardController.isLoading.value
                ? Container()
                : Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events,
                            color: Colors.amber, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          "${dashboardController.userRank.value}${Utils.getNumberSuffix(dashboardController.userRank.value)}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
      actions: [
        // Language Dropdown
        Obx(() {
          final languageController = Get.find<LanguageController>();
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: languageController.appLocale?.languageCode ?? 'en',
              dropdownColor: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
              style: TextStyle(fontSize: 11.sp, color: Colors.white),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  languageController.changeLanguage(
                    newValue,
                    newValue == 'bn' ? 'BD' : 'US',
                  );
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('🇺🇸 EN'),
                ),
                DropdownMenuItem(
                  value: 'bn',
                  child: Text('🇧🇩 BN'),
                ),
              ],
            ),
          );
        }),
        // More Menu
        PopupMenuButton(
          color: Colors.white,
          icon: Icon(Icons.more_vert, color: Colors.white, size: 22.sp),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          "${dashboardController.username.value}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    SizedBox(height: 10.h),
                    Divider(
                      color: AppColors.primary.withOpacity(0.2),
                      height: 1,
                    ),
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: () async {
                        StorageHelper.removeLanguageSettings();
                        StorageHelper.removeToken();
                        StorageHelper.removeFullName();
                        StorageHelper.removeUserData();
                        StorageHelper.removeUserId();
                        StorageHelper.removeUserName();
                        Get.delete<DashboardController>(force: true);
                        Get.delete<UserPointsController>(force: true);
                        Get.delete<RamadanPlannerController>(force: true);
                        Get.delete<TrackingController>(force: true);
                        Get.delete<QuickJumpSectionController>(force: true);
                        Get.toNamed(Routes.login);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: Colors.redAccent, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ];
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
