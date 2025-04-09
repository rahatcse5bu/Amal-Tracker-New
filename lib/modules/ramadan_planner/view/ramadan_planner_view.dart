import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Credit.dart';
import '../../../Tracking-Old.dart';
import '../../../app/common/controller/nav_controller.dart';
import '../../../app/common/utils/ramadan_utils.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/translation/language_controller.dart';
import '../../../app/translation/translation_keys.dart';
import '../../../widgets/Good_Afternoon_Todo.dart';
import '../../main/controller/main_controller.dart';
import '../controller/quick_jump_section_controller.dart';
import '../controller/ramadan_planner_controller.dart';
import 'package:expandable_text/expandable_text.dart';

import '../controller/tracking_controller.dart';
import '../widgets/achievement_card_widget.dart';
import '../widgets/asmaul_husna_widget.dart';
import '../widgets/quick_jump_section_widget.dart';
import '../widgets/tracking_widget.dart';

class RamadanPlannerView extends GetView<RamadanPlannerController> {
  final QuickJumpSectionController _quickjumpController = Get.find();
  final NavController navController = Get.put(NavController());
  final MainController mainController = Get.put(MainController());

  
  @override
  Widget build(BuildContext context) {
    int ramadanDay = Get.arguments['ramadan_day'] ?? 1;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.fromLTRB(10.w, 0, 2.w, 0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: AppColors.primary,
        title: Text(
          '$ramadanDay${Utils.getNumberSuffix(ramadanDay)} রমাদ্বন ${controller.currentYear.value}',
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(() => SingleChildScrollView(
                controller: _quickjumpController.scrollController,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Column(
                  children: [
                    // Points Card

                    Padding(
                      padding: EdgeInsets.all(10.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6.r),
                              topRight: Radius.circular(6.r)),
                          color: AppColors.primary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${ TranslationKeys.todayPoint.tr}: ${controller.todaysPoint.value}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                  color: Colors.white),
                            ),
                            InkWell(
                                onTap: () {
                                  _quickjumpController.showGrid.value =
                                      !_quickjumpController.showGrid.value;
                                },
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      !_quickjumpController.showGrid.value
                                          ? Icons.filter_alt
                                          : Icons.close,
                                      color: AppColors.primary,
                                    )))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _quickjumpController.showGrid.value,
                        child: SizedBox(
                            height: 140.h, child: QuickJumpSections())),
                    // Hadith and Ayat Cards
                    Column(
                      children: [
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  margin: EdgeInsets.only(bottom: 5.h),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6.r),
                                        topRight: Radius.circular(6.r)),
                                    color: AppColors.primary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${TranslationKeys.todayHadidth.tr}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20.sp),
                                    ),
                                  ),
                                ),
                                controller.isLoadingHadith.value
                                    ? Center(
                                        child: CupertinoActivityIndicator(
                                        color: AppColors.primary,
                                      ))
                                    : ExpandableText(
                                        Get.find<LanguageController>()
                                                    .appLocale
                                                    ?.languageCode ==
                                                'bn'
                                            ? controller.HadithList.first
                                                .bnText // Show Bengali Text
                                            : controller.HadithList.first
                                                .enText, // Show English Text
                                        expandText: Get.find<
                                                        LanguageController>()
                                                    .appLocale
                                                    ?.languageCode ==
                                                'bn'
                                            ? 'আরো দেখুন' // Bengali for "show more"
                                            : 'Show more',
                                        collapseText: Get.find<
                                                        LanguageController>()
                                                    .appLocale
                                                    ?.languageCode ==
                                                'bn'
                                            ? 'কম দেখান' // Bengali for "show less"
                                            : 'Show less',
                                        maxLines: 4,
                                        linkColor: Colors.blue,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12.sp,
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  margin: EdgeInsets.only(bottom: 5.h),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6.r),
                                        topRight: Radius.circular(6.r)),
                                    color: AppColors.primary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${TranslationKeys.todayVerse.tr}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                controller.isLoadingAyat.value
                                    ? Center(
                                        child: CupertinoActivityIndicator(
                                        color: AppColors.primary,
                                      ))
                                    : ExpandableText( 
                                         Get.find<LanguageController>()
                                                    .appLocale
                                                    ?.languageCode ==
                                                'bn'
                                            ? controller.ajkerAyat.first
                                                .bnText // Show Bengali Text
                                            : controller.ajkerAyat.first
                                                .enText, 
                                   expandText: Get.find<
                                                        LanguageController>()
                                                    .appLocale
                                                    ?.languageCode ==
                                                'bn'
                                            ? 'আরো দেখুন' // Bengali for "show more"
                                            : 'Show more',
                                        collapseText: Get.find<
                                                        LanguageController>()
                                                    .appLocale
                                                    ?.languageCode ==
                                                'bn'
                                            ? 'কম দেখান' // Bengali for "show less"
                                            : 'Show less',
                                        maxLines: 4,
                                        linkColor: Colors.blue,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12.sp),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Tracking Widgets
                    if (ramadanDay > 20)
                      Container(
                        key: _quickjumpController.sectionKeys['qadr']
                            ?['key'], // Assign the GlobalKey

                        child: TrackingWidget(
                            ramadan_day: ramadanDay,
                            type: 'switch',
                            slug: 'qadr_tracking'),
                      ),
                    Container(
                      key: _quickjumpController.sectionKeys['night']
                          ?['key'], // Assign Global Key,
                      child: TrackingWidget(
                          ramadan_day: ramadanDay,
                          type: 'switch',
                          slug: 'night_tracking'),
                    ),
                    Container(
                      key: _quickjumpController.sectionKeys['fajr']
                          ?['key'], // Assign Global Key,
                      child: TrackingWidget(
                          ramadan_day: ramadanDay,
                          type: 'checkbox',
                          slug: 'fajr_tracking'),
                    ),
                    Container(
                      key: _quickjumpController.sectionKeys['zuhr']
                          ?['key'], // Assign Global Key,

                      child: TrackingWidget(
                          ramadan_day: ramadanDay,
                          type: 'switch',
                          slug: 'zuhr_tracking'),
                    ),
                    // Dua Card
                    Column(
                      children: [
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  margin: EdgeInsets.only(bottom: 5.h),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6.r),
                                        topRight: Radius.circular(6.r)),
                                    color: AppColors.primary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "আজকের দু'আ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                controller.isLoadingDua.value
                                    ? Center(
                                        child: CupertinoActivityIndicator(
                                        color: AppColors.primary,
                                      ))
                                    : Text(
                                        controller.ajkerDuaTitle.value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                            color: Colors.black),
                                      ),
                                SizedBox(height: 10.h),
                                controller.isLoadingDua.value
                                    ? Center(
                                        child: CupertinoActivityIndicator(
                                        color: AppColors.primary,
                                      ))
                                    : ExpandableText(
                                        controller.ajkerDuaArabic.value,
                                        expandText: 'show more',
                                        collapseText: 'show less',
                                        maxLines: 4,
                                        linkColor: AppColors.primary,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 18.sp),
                                      ),
                                SizedBox(height: 10.h),
                                controller.isLoadingDua.value
                                    ? Center(
                                        child: CupertinoActivityIndicator(
                                        color: AppColors.primary,
                                      ))
                                    : ExpandableText(
                                        controller.ajkerDuaBangla.value,
                                        expandText: 'show more',
                                        collapseText: 'show less',
                                        maxLines: 4,
                                        linkColor: AppColors.primary,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12.sp),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Additional Tracking Widgets
                    Container(
                      key: _quickjumpController.sectionKeys['common']
                          ?['key'], // Assign Global Key,

                      child: TrackingWidget(
                          ramadan_day: ramadanDay,
                          type: 'switch',
                          slug: 'general_tracking'),
                    ),
                  // ramadanDay>20?  Container(
                  //     key: _quickjumpController.sectionKeys['qadr']
                  //         ?['key'], // Assign Global Key,

                  //     child: TrackingWidget(
                  //         ramadan_day: ramadanDay,
                  //         type: 'switch',
                  //         slug: 'qadr_tracking'),
                  //   ):Container(),
                    Container(
                        key: _quickjumpController.sectionKeys['other']
                            ?['key'], // Assign Global Key,
                        child: Good_Afternoon_Todo(ramadan_day: ramadanDay)),

                    Container(
                      key: _quickjumpController.sectionKeys['asr']
                          ?['key'], // Assign Global Key,

                      child: TrackingWidget(
                          ramadan_day: ramadanDay,
                          type: 'switch',
                          slug: 'asr_tracking'),
                    ),
                    Container(
                      key: _quickjumpController.sectionKeys['maghrib']
                          ?['key'], // Assign Global Key,

                      child: TrackingWidget(
                          ramadan_day: ramadanDay,
                          type: 'checkbox',
                          slug: 'evening_tracking'),
                    ),
                    SizedBox(height: 10.h),
                    // Asmaul Husna & Credit
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      margin: EdgeInsets.only(bottom: 5.h),
                      width: 1.sw,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60.r),
                              topRight: Radius.circular(60.r)),
                          color: AppColors.primary),
                      child: Center(
                          child: Text("আসমাউল হুসনা:",
                              style: TextStyle(
                                  fontSize: 25.sp, color: Colors.white))),
                    ),
                    AsmaulHusnaWidget(),
                    // // Special Achievement Card
                    Container(
                        key: _quickjumpController.sectionKeys['special']
                            ?['key'], // Assign Global Key,
                        child: AchievementWidget(ramadan_day: ramadanDay)),
                    // // Credit Widget
                    Credit(),
                  ],
                ),
              )),
          // "Back to Top" Button
          Obx(() => _quickjumpController.showBackToTop.value
              ? Positioned(
                  bottom: 20.h,
                  right: 20.w,
                  child: FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    onPressed: _quickjumpController.scrollToTop,
                    child: Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                )
              : SizedBox.shrink()), // Hide when not needed
        ],
      ),
      //     bottomNavigationBar: Obx(
      //   () => BottomNavigationBar(
      //     // iconSize: 16.sp,
      //     // unselectedLabelStyle: TextStyle(fontSize: 11.sp),
      //     backgroundColor: Colors.white,
      //     currentIndex: navController.currentIndex.value,
      //     showSelectedLabels: true,
      //     // onTap: controller.changeTab,
      //     onTap: (index) {
      //       if (index == 1) {
      //         mainController.openMoreBottomSheet();
      //       } 
      //       else if (index == 2) {
      //         mainController.openMoreBottomSheet();
      //       } 
      //       else {
      //         navController.changeTab(index);
      //       }
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: TranslationKeys.home.tr,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.leaderboard),
      //         label: TranslationKeys.leaderBoard.tr,
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.more_horiz),
      //         label: TranslationKeys.more.tr,
      //       ),
      //     ],
      //     selectedItemColor: AppColors.primary,
      //     unselectedItemColor: Colors.grey,
      //   ),
      // ),
    );
  }
}
