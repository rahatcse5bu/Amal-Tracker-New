import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_color.dart';
import '../widgets/amal_tracking_widget.dart';

class RamadanPlannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final slug = arguments['slug'];
    final title = arguments['title'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
      ),
      body: AmalTracker(
        ramadan_day: DateTime.now().day, // Example: Current day
        slug: slug,
        type: 'checkbox',
      ),
    );
  }
}
