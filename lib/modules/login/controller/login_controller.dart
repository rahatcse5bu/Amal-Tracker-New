import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/app/common/storage/storage_controller.dart';

import '../../../app/apis/api_helper.dart';
import '../../../app/routes/app_pages.dart';
import '../models/login_request_model.dart';

class LoginController extends GetxController {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  var isLoading = false.obs;

  Future<void> login() async {
    isLoading(true);
    final loginData = LoginRequestModel(
      identifier: identifierController.text,
      password: passwordController.text,
    );

    final result = await _apiHelper.login(loginData);
    isLoading(false);

    result.fold(
      (error) {
        Fluttertoast.showToast(
          msg: "Login Failed: ${error.message}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      },
      (response) async {
        await StorageHelper.setToken(response.token);
        await StorageHelper.setUserId(response.userId);
        await StorageHelper.setUserName(response.userName);
        await StorageHelper.setFullName(response.fullName);

        Fluttertoast.showToast(
          msg: "আপনার লগিন সফল হয়েছে",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        Get.toNamed(Routes.home);
      },
    );
  }
}