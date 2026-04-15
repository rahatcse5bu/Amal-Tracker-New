import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_color.dart';
import '../controller/amal_controller.dart';

class AmalView extends GetView<AmalController> {
  const AmalView({Key? key}) : super(key: key);

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
              'আমাল চ্যালেঞ্জ',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: controller.timeRemaining.value <= 10
                      ? Colors.red.withOpacity(0.3)
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      color: controller.timeRemaining.value <= 10
                          ? Colors.red[300]
                          : Colors.white,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${controller.timeRemaining.value}s',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: controller.timeRemaining.value <= 10
                            ? Colors.red[300]
                            : Colors.white,
                      ),
                    ),
                  ],
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
              // Paragraph Section
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'প্যারাগ্রাফ পড়ুন:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        controller.currentParagraph.value,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Timer progress bar
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'সময় বাকি:',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${controller.timeRemaining.value}s / ${controller.timerDuration}s',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: controller.timeRemaining.value <= 10
                                  ? Colors.red
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: controller.timeRemaining.value / controller.timerDuration,
                          minHeight: 6.h,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            controller.timeRemaining.value <= 10
                                ? Colors.red
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Counter Section - Compact
              Text(
                'শব্দ গণনা:',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),

              // Counters Grid
              _buildCompactCounter(
                label: 'سُبْحَانَ',
                digit: 'ক',
                color: Colors.blue,
                count: controller.userCountSubhanallah,
                onIncrement: controller.incrementSubhanallah,
                onDecrement: controller.decrementSubhanallah,
              ),
              SizedBox(height: 8.h),
              _buildCompactCounter(
                label: 'الْحَمْد',
                digit: 'খ',
                color: Colors.green,
                count: controller.userCountAlhamdulillah,
                onIncrement: controller.incrementAlhamdulillah,
                onDecrement: controller.decrementAlhamdulillah,
              ),
              SizedBox(height: 8.h),
              _buildCompactCounter(
                label: 'اللَّهُ',
                digit: 'গ',
                color: Colors.orange,
                count: controller.userCountAllahuAkbar,
                onIncrement: controller.incrementAllahuAkbar,
                onDecrement: controller.decrementAllahuAkbar,
              ),
              SizedBox(height: 16.h),

              // Buttons
              Obx(
                () => controller.isSubmitted.value
                    ? _buildResultSection()
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: controller.resetCounts,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                side: BorderSide(
                                  color: Colors.grey[400]!,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                'রিসেট',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controller.submitCounts,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                'জমা',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCounter({
    required String label,
    required String digit,
    required Color color,
    required RxInt count,
    required Function() onIncrement,
    required Function() onDecrement,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label & Digit
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    digit,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          // Counter
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onDecrement,
                  icon: Icon(Icons.remove, color: color, size: 16.sp),
                  splashRadius: 16.r,
                  padding: EdgeInsets.all(4.w),
                  constraints: BoxConstraints(
                    minHeight: 28.w,
                    minWidth: 28.w,
                  ),
                ),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      count.value.toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onIncrement,
                  icon: Icon(Icons.add, color: color, size: 16.sp),
                  splashRadius: 16.r,
                  padding: EdgeInsets.all(4.w),
                  constraints: BoxConstraints(
                    minHeight: 28.w,
                    minWidth: 28.w,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Column(
      children: [
        // Score Card - Compact
        Container(
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
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'স্কোর',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white70,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${controller.score.value.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Obx(
                () => Text(
                  controller.getResultMessage(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        // Results Details - Compact
        _buildSmallResultDetail(
          'ক তালিকা',
          controller.userCountSubhanallah,
          controller.actualCountSubhanallah,
          Colors.blue,
        ),
        SizedBox(height: 6.h),
        _buildSmallResultDetail(
          'খ তালিকা',
          controller.userCountAlhamdulillah,
          controller.actualCountAlhamdulillah,
          Colors.green,
        ),
        SizedBox(height: 6.h),
        _buildSmallResultDetail(
          'গ তালিকা',
          controller.userCountAllahuAkbar,
          controller.actualCountAllahuAkbar,
          Colors.orange,
        ),
        SizedBox(height: 12.h),

        // Next Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.generateNewParagraph,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'পরবর্তী ✨',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallResultDetail(
    String label,
    RxInt userCount,
    int actualCount,
    Color color,
  ) {
    bool isCorrect = userCount.value == actualCount;

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.08) : Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isCorrect ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'আপনার: ${userCount.value}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'সঠিক: $actualCount',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
