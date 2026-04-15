import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:amal_tracker/modules/dashboard/controller/user_points_controller.dart';

import '../../../app/constants/app_color.dart';
import '../../../app/translation/language_controller.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/dashboard_controller.dart';

class LeaderboardWidget extends GetView<UserPointsController> {
  final bool? isLeaderboardPage;
  LeaderboardWidget({super.key, this.isLeaderboardPage});
  final DashboardController _dashboardController = Get.find();

  Widget _buildMedalIcon(int rank) {
    switch (rank) {
      case 1:
        return Icon(Icons.emoji_events, color: const Color(0xFFFFD700), size: 28.sp);
      case 2:
        return Icon(Icons.emoji_events, color: const Color(0xFFC0C0C0), size: 28.sp);
      case 3:
        return Icon(Icons.emoji_events, color: const Color(0xFFCD7F32), size: 28.sp);
      default:
        return Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: Colors.white,
      child: Column(
        children: [
          // Loading or Leaderboard List
          if (_dashboardController.isLoading.value)
            Center(
              child: SizedBox(
                height: 200.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          else
            Column(
              children: [
                // Top 3 Podium Section
                if (_dashboardController.users.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.08),
                          Colors.white,
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
                    child: Column(
                      children: [
                        // Podium
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // 2nd Place
                            if (_dashboardController.users.length > 1)
                              Expanded(
                                child: _buildPodiumCard(
                                  user: _dashboardController.users[1],
                                  rank: 2,
                                  height: 100.h,
                                ),
                              ),
                            SizedBox(width: 8.w),
                            // 1st Place
                            Expanded(
                              child: _buildPodiumCard(
                                user: _dashboardController.users[0],
                                rank: 1,
                                height: 140.h,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // 3rd Place
                            if (_dashboardController.users.length > 2)
                              Expanded(
                                child: _buildPodiumCard(
                                  user: _dashboardController.users[2],
                                  rank: 3,
                                  height: 75.h,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                
                // Rest of Rankings
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    children: [
                      if (_dashboardController.users.length > 3)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.isShowAll.value
                              ? _dashboardController.users.length - 3
                              : (controller.visibleCount.value <
                                      _dashboardController.users.length - 3
                                  ? controller.visibleCount.value
                                  : _dashboardController.users.length - 3),
                          itemBuilder: (context, index) {
                            final actualIndex = index + 3;
                            final user = _dashboardController.users[actualIndex];
                            final currentUser = _dashboardController.username.value;
                            final isCurrentUser = user.userName == currentUser;

                            return _buildLeaderboardCard(
                              user: user,
                              rank: actualIndex + 1,
                              isCurrentUser: isCurrentUser,
                              index: index,
                            );
                          },
                        ),
                      
                      // Show More/Less Button
                      if (_dashboardController.users.length > 3 &&
                          (_dashboardController.users.length - 3 >
                                  controller.visibleCount.value ||
                              controller.isShowAll.value))
                        Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: MaterialButton(
                            onPressed: () {
                              controller.handleShowAll();
                            },
                            height: 44.h,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  controller.isShowAll.value
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: AppColors.primary,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  controller.isShowAll.value
                                      ? Get.find<LanguageController>()
                                                  .appLocale
                                                  ?.languageCode ==
                                              'bn'
                                          ? 'কম দেখুন'
                                          : 'Show less'
                                      : Get.find<LanguageController>()
                                                  .appLocale
                                                  ?.languageCode ==
                                              'bn'
                                          ? 'আরো দেখুন'
                                          : 'Show more',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    ));
  }

  Widget _buildPodiumCard({
    required dynamic user,
    required int rank,
    required double height,
  }) {
    final medalColors = {
      1: {'primary': Color(0xFFFFD700), 'light': Color(0xFFFFF9E6)},
      2: {'primary': Color(0xFFC0C0C0), 'light': Color(0xFFF5F5F5)},
      3: {'primary': Color(0xFFCD7F32), 'light': Color(0xFFFFF4E6)},
    };

    final colors = medalColors[rank]!;

    return Column(
      children: [
        // User Avatar with Badge
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (colors['primary'] as Color).withOpacity(0.9),
                (colors['primary'] as Color).withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: (colors['primary'] as Color).withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
                size: 32.sp,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: colors['primary'] as Color,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: colors['primary'],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Medal Icon
        Icon(
          Icons.emoji_events,
          color: colors['primary'],
          size: 40.sp,
        ),
        SizedBox(height: 12.h),
        // Podium Card
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                (colors['light'] as Color).withOpacity(0.8),
                (colors['light'] as Color).withOpacity(0.4),
              ],
            ),
            border: Border.all(
              color: (colors['primary'] as Color).withOpacity(0.4),
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: (colors['primary'] as Color).withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(10.h),
                child: Text(
                  user.userName ?? 'N/A',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${user.totalPoints}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: colors['primary'],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colors['primary'],
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: (colors['primary'] as Color).withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      '#$rank',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard({
    required dynamic user,
    required int rank,
    required bool isCurrentUser,
    required int index,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCurrentUser
                ? [
                    AppColors.primary.withOpacity(0.12),
                    AppColors.primary.withOpacity(0.06),
                  ]
                : [
                    Colors.grey[50]!,
                    Colors.white,
                  ],
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isCurrentUser
                ? AppColors.primary.withOpacity(0.5)
                : Colors.grey[200]!,
            width: isCurrentUser ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCurrentUser
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, isCurrentUser ? 4 : 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCurrentUser
                      ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
                      : [Colors.grey[400]!, Colors.grey[300]!],
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: (isCurrentUser ? AppColors.primary : Colors.grey[400]!)
                        .withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.userName ?? 'N/A',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w600,
                      color: isCurrentUser
                          ? AppColors.primary
                          : const Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    user.fullName ?? 'N/A',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Points Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCurrentUser
                      ? [AppColors.primary, AppColors.primary.withOpacity(0.8)]
                      : [Colors.amber, Colors.amber.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: (isCurrentUser ? AppColors.primary : Colors.amber)
                        .withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 15.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${user.totalPoints}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
