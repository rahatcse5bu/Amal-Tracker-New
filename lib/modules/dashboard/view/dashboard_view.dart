import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:amal_tracker/modules/dashboard/widgets/leaderboard_widget.dart';
import 'package:amal_tracker/modules/dashboard/widgets/quote_widget.dart';
import 'package:amal_tracker/modules/dashboard/widgets/ramadan_days_list.dart';
import 'package:amal_tracker/Data/data.dart';

import '../../../app/constants/app_color.dart';
import '../../../app/translation/translation_keys.dart';
import '../controller/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                // Header Section with Greeting
                _buildHeader(context),
                SizedBox(height: 24.h),
                
                // Main Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      // Leaderboard Section
                      LeaderboardWidget(),
                      SizedBox(height: 28.h),
                      
                      // Daily Inspirations Header
                      _buildSectionHeader(
                        title: "আজকের অনুপ্রেরণা",
                        subtitle: "দৈনিক বার্তা এবং উপদেশ",
                      ),
                      SizedBox(height: 16.h),
                      
                      // Quote Widgets
                      controller.AyatList.isNotEmpty
                          ? QuoteWidget(
                              title: TranslationKeys.selectedVerses.tr,
                              text: controller.AyatList.first.enText,
                              type: 'ajker_ayat')
                          : const _LoadingCard(),
                      SizedBox(height: 16.h),
                      
                      controller.HadithList.isNotEmpty
                          ? QuoteWidget(
                              title: "নির্বাচিত হাদিস",
                              text: controller.HadithList.first.enText,
                              type: 'ajker_hadith')
                          : const _LoadingCard(),
                      SizedBox(height: 16.h),
                      
                      controller.salafQuotes.isNotEmpty
                          ? QuoteWidget(
                              title: "সালাফদের বক্তব্য",
                              text: controller.salafQuotes.first.enText,
                              type: 'salaf_quote')
                          : const _LoadingCard(),
                      SizedBox(height: 28.h),
                      
                      // Ramadan Days Section Header
                      _buildSectionHeader(
                        title: "রমজান ট্র্যাকার",
                        subtitle: "প্রতিটি দিনের অগ্রগতি ট্র্যাক করুন",
                      ),
                      SizedBox(height: 16.h),
                      
                      // Ramadan Days List
                      RamadanDaysList(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final currentDate = DateTime.now();
    final ramadanDay = calculate2025RamadanDate();
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Text
          Text(
            'আস্সালামু আলাইকুম!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          
          // Date and Ramadan Info
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.white, size: 16.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'রমজান দিন $ramadanDay • ${currentDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CupertinoActivityIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
