import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_color.dart';
import '../controller/quick_jump_section_controller.dart';

class QuickJumpSections extends GetWidget<QuickJumpSectionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Jump to Section Grid")),
      body: Column(
        children: [
          // Grid of Buttons
          Padding(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.sectionKeys.keys.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                String section = controller.sectionKeys.keys
                    .elementAt(index); // Get section key (slug)
                String bnTitle = controller.sectionKeys[section]?['bnTitle'] ??
                    section; // Get bnTitle or fallback to slug
                return GestureDetector(
                  onTap: () { 
                    log("sectionnn: ${section}");
                    controller.scrollToSection(section);},
                  child: Card(
                    color: AppColors.primary,
                    
                    elevation: 4,
                    child: Center(
                      child: Text(
                        bnTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
