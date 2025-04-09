import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../app/common/widgets/cuatom_text_field_widget.dart' show CustomTextField;
import '../../../app/constants/app_color.dart';
import '../controller/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        leading: Container(
       
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                   Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15.3.r)),
                  child: Image.asset("images/Ramadan_Tracker.png")),
                  SizedBox(height: 16.h),
              CustomTextField(
                controller: controller.usernameController,
                label: 'Username',
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: controller.fullNameController,
                label: 'Full Name',
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: controller.emailController,
                label: 'Email',
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
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: controller.register,
                        child: Text('Register'),
                      ),
                    )),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Get.toNamed('/login');
                },
                child: Text(
                  "Already have an account? Login here",
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
