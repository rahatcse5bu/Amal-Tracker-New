import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ramadan_tracker/app/routes/app_pages.dart';
import '../../../app/apis/api_helper.dart';
import '../../../app/constants/app_color.dart';
import '../models/register_model.dart';

class RegisterController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  var isLoading = false.obs;

  Future<void> register() async {
    isLoading(true);
    final registerData = RegisterRequestModel(
      userName: usernameController.text,
      fullName: fullNameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    final result = await _apiHelper.register(registerData);
    isLoading(false);

    result.fold(
      (error) {
        Fluttertoast.showToast(
          msg: "Registration Failed: ${error.message}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      },
      (response) {
        Fluttertoast.showToast(
          msg: "আপনার রেজি সফল হয়েছে",
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
        );

        Get.offNamed(Routes.login);
      },
    );
  }
}
