import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_color.dart';
import '../controller/adhkar_controller.dart';

class AdhkarView extends GetView<AdhkarController> {
  const AdhkarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'আধকার (জিকির)',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'মোট: ${controller.totalCount.value}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        leading: SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'প্রতিটি জিকির লক্ষ্য সংখ্যায় পৌঁছে গেলে সম্পন্ন হবে',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // Dhikrs List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.dhikrs.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  return _buildDhikrCard(index);
                },
              ),

              SizedBox(height: 12.h),

              // Reset All Button
              Obx(
                () => controller.totalCount.value > 0
                    ? SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: controller.resetAllCounters,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            side: BorderSide(
                              color: Colors.red[300]!,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            'সবকিছু রিসেট করুন',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red[300],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDhikrCard(int index) {
    final dhikr = controller.dhikrs[index];
    return Obx(
      () {
        bool isCompleted = controller.isTargetReached(index);
        double progress = controller.getProgressPercentage(index);

        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isCompleted
                  ? Colors.green.withOpacity(0.3)
                  : AppColors.primary.withOpacity(0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isCompleted
                    ? Colors.green.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dhikr.arabicText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          dhikr.bengaliText,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          '${dhikr.count.value}/${dhikr.targetCount}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? Colors.green : AppColors.primary,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          'মোট: ${dhikr.sessionTotal.value}/${dhikr.completedCycles.value * dhikr.targetCount + dhikr.targetCount}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              '✓ সম্পন্ন',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Meaning
              Text(
                dhikr.meaning,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),

              SizedBox(height: 8.h),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 4.h,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? Colors.green : AppColors.primary,
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Counter buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Minus button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      onPressed: () => controller.decrementCounter(index),
                      icon: Icon(
                        Icons.remove,
                        color: Colors.grey[700],
                        size: 18.sp,
                      ),
                      padding: EdgeInsets.all(4.w),
                      constraints: BoxConstraints(
                        minHeight: 32.w,
                        minWidth: 32.w,
                      ),
                    ),
                  ),

                  // Count display
                  Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        dhikr.count.value.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isCompleted ? Colors.green : AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  // Plus button
                  Container(
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      onPressed: () => controller.incrementCounter(index),
                      icon: Icon(
                        Icons.add,
                        color: isCompleted ? Colors.green : AppColors.primary,
                        size: 18.sp,
                      ),
                      padding: EdgeInsets.all(4.w),
                      constraints: BoxConstraints(
                        minHeight: 32.w,
                        minWidth: 32.w,
                      ),
                    ),
                  ),

                  // Reset button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      onPressed: () => controller.resetCounter(index),
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.orange[700],
                        size: 16.sp,
                      ),
                      padding: EdgeInsets.all(4.w),
                      constraints: BoxConstraints(
                        minHeight: 32.w,
                        minWidth: 32.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
