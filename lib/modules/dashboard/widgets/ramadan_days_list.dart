import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:amal_tracker/Data/data.dart';

import '../../../app/common/utils/ramadan_utils.dart';
import '../../../app/constants/app_color.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/dashboard_controller.dart';

class RamadanDaysList extends GetWidget<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < controller.ramadanList.length; i++) ...[
          _buildRamadanDayCard(
            context,
            dayNumber: i + 1,
            dayValue: controller.ramadanList[i],
            index: i,
          ),
          if (i < controller.ramadanList.length - 1)
            SizedBox(height: 12.h),
        ],
      ],
    );
  }

  Widget _buildRamadanDayCard(
    BuildContext context, {
    required int dayNumber,
    required int dayValue,
    required int index,
  }) {
    final currentRamadanDay = calculate2025RamadanDate();
    final isCurrentDay = dayNumber == currentRamadanDay &&
        controller.current_month == "Ramadan";
    final isCompletedDay = dayNumber < currentRamadanDay &&
        controller.current_month == "Ramadan";
    final isOddNight = dayNumber > 20 &&
        (dayNumber == 21 || dayNumber == 23 || dayNumber == 25 ||
            dayNumber == 27 || dayNumber == 29);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.ramadanPlanner,
              arguments: {'ramadan_day': dayNumber});
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          decoration: BoxDecoration(
            color: isCurrentDay
                ? AppColors.primary.withOpacity(0.08)
                : isCompletedDay
                    ? Colors.grey[50]
                    : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCurrentDay
                  ? AppColors.primary
                  : isCompletedDay
                      ? Colors.grey[300]!
                      : Colors.grey[200]!,
              width: isCurrentDay ? 2 : 1,
            ),
            boxShadow: [
              if (isCurrentDay)
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              else
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              // Day Badge
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentDay
                      ? AppColors.primary
                      : isCompletedDay
                          ? Colors.grey[300]
                          : Colors.grey[100],
                  boxShadow: [
                    if (isCurrentDay)
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isCurrentDay
                          ? Colors.white
                          : isCompletedDay
                              ? Colors.white
                              : AppColors.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Day Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${TranslationKeys.ramadan.tr} - $dayValue${Utils.getNumberSuffix(dayValue)}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: isCurrentDay
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isCurrentDay
                                ? AppColors.primary
                                : isCompletedDay
                                    ? Colors.grey[600]
                                    : const Color(0xFF1A1A1A),
                          ),
                        ),
                        if (isCurrentDay)
                          SizedBox(width: 8.w),
                        if (isCurrentDay)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              TranslationKeys.today.tr,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      TranslationKeys.trackRamadan.tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isCurrentDay
                            ? AppColors.primary.withOpacity(0.7)
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Action Icon
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isCurrentDay
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  isOddNight && dayNumber > 20
                      ? Icons.diamond_rounded
                      : Icons.arrow_forward_ios,
                  color: isCurrentDay
                      ? AppColors.primary
                      : isCompletedDay
                          ? Colors.grey[400]
                          : AppColors.primary.withOpacity(0.6),
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
