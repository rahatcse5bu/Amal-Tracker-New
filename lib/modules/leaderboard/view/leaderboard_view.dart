import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/common/widgets/custom_appbar_widget.dart';
import '../../dashboard/widgets/leaderboard_widget.dart';

class LeaderboardView extends StatelessWidget {

  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
        title: 'Leaderboard',
        centerTitle: true,
        leadingIcon: Icons.arrow_back,
        onLeadingPressed: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
          child: LeaderboardWidget(),
        ),
      ),
    );
  }
}