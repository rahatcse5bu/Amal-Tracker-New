// 4. Implement in View
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/common/controller/nav_controller.dart';
import '../../../app/common/widgets/custom_appbar_widget.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/translation/translation_keys.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../dashboard/widgets/leaderboard_widget.dart';
import '../controller/main_controller.dart';

class MainView extends StatelessWidget {
  final NavController controller = Get.put(NavController());
  final MainController mainController = Get.put(MainController());
  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(title: '', leadingWidget: null,leadingWidth: 90.w, onLeadingPressed: ()=>
        Get.back()
      ),
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return DashboardView();
          case 1:
            return LeaderboardWidget(
              isLeaderboardPage: true,
            );
          case 2:
            return Wrap();

          default:
            return DashboardView();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          // iconSize: 16.sp,
          // unselectedLabelStyle: TextStyle(fontSize: 11.sp),
          backgroundColor: Colors.white,
          currentIndex: controller.currentIndex.value,
          showSelectedLabels: true,
          // onTap: controller.changeTab,
          onTap: (index) {
            if (index == 2) {
              mainController.openMoreBottomSheet();
            } else {
              controller.changeTab(index);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: TranslationKeys.home.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: TranslationKeys.leaderBoard.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: TranslationKeys.more.tr,
            ),
          ],
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

