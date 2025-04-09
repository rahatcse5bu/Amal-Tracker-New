import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/app/routes/app_pages.dart';
import 'package:ramadan_tracker/modules/login/controller/login_controller.dart';

import '../../../app/common/widgets/cuatom_text_field_widget.dart';
import '../../../app/constants/app_color.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Container(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15.3.r)),
                  child: Image.asset("images/Ramadan_Tracker.png")),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: controller.identifierController,
                label: 'Username/Email',
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: controller.passwordController,
                label: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator(color: AppColors.primary,)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                      ),
                      onPressed: controller.login,
                      child: Text('Login', style: TextStyle(fontSize: 20.sp)),
                    )),
              SizedBox(height: 15.h),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.register);
                },
                child: Text(
                  "New to Ramadan Tracker? Register here",
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
