import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../modules/dashboard/controller/dashboard_controller.dart';
import '../../../modules/dashboard/controller/user_points_controller.dart';
import '../../../modules/ramadan_planner/controller/quick_jump_section_controller.dart';
import '../../../modules/ramadan_planner/controller/ramadan_planner_controller.dart';
import '../../../modules/ramadan_planner/controller/tracking_controller.dart';
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
      leadingWidth: leadingWidth ?? 180,
      title: Obx(() => dashboardController.isLoading.value
          ? CupertinoActivityIndicator(
              color: AppColors.primary,
            )
          : Text("${dashboardController.totalPoints.value} pts",
              style: TextStyle(fontSize: 10.sp, color: Colors.white))),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      automaticallyImplyLeading: true,
      actions: actions ??
          <Widget>[
            // In your settings screen/widget
            Obx(
              () {
                final languageController = Get.find<LanguageController>();

                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: languageController.appLocale?.languageCode ?? 'en',
                    // icon: Icon(Icons.language, color: Colors.white),
                    // isExpanded: true,
                    dropdownColor: AppColors.primary,

                    borderRadius: BorderRadius.circular(12.r),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
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
                        child: Row(
                          children: [
                            Text('🇺🇸'), // Optional flag icon
                            SizedBox(width: 5.w),
                            Text(
                              'English',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'bn',
                        child: Row(
                          children: [
                            Text('🇧🇩'), // Optional flag icon
                            SizedBox(width: 5.w),
                            Text(
                              'বাংলা',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            PopupMenuButton(
              color: Colors.white,
              icon: Icon(
                Icons.more_vert,
                color: Colors
                    .white, // Change the color of the vertical three dots here
              ),
              itemBuilder: (BuildContext context) {
                return [
                  // Language Selection Items
                  // PopupMenuItem(
                  //   child: GetBuilder<LanguageController>(
                  //     builder: (controller) {
                  //       return Column(
                  //         children: [
                  //           _buildLanguageItem(context,
                  //               languageCode: 'en', label: 'English'),
                  //           _buildLanguageItem(context,
                  //               languageCode: 'bn', label: 'বাংলা'),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),
                  PopupMenuItem(
                    child: Column(
                      children: [
                        Text("${dashboardController.username.value}"),
                        SizedBox(height: 10.h),
                        Divider(
                          color: AppColors.primary,
                          height: 1,
                          endIndent: 5.w,
                          indent: 5.w,
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                            onTap: () async {
// Ensure the LocalStorage is ready before setting items
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
                              Get.delete<QuickJumpSectionController>(
                                  force: true);

                              // Redirect to login page
                              Get.toNamed(Routes.login);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 5.h),
                                Text('Logout'),
                              ],
                            )),
                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
      leading: Row(
        children: [
          leadingWidget != null
              ? Expanded(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                )
              : Container(
                  child: SizedBox(
                    width: 15.w,
                  ),
                ),
          Obx(() => dashboardController.isLoading.value
              ? CupertinoActivityIndicator(
                  color: AppColors.primary,
                )
              : Text(
                "${TranslationKeys.rank.tr}:${dashboardController.userRank.value}${Utils.getNumberSuffix(dashboardController.userRank.value)}",
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
              )),
        ],
      ),
    );
  }
}
