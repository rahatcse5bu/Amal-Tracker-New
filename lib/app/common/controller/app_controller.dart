import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../APIs/api_helper.dart';
import '../utils/ramadan_utils.dart';

class AppController extends GetxController {
    final ApiHelper _apiHelper = Utils.getApiHelperController();

  // Example of global variables
  var username = ''.obs; // Reactive variable
  var isLoggedIn = false.obs;
  var appTheme = 'light'.obs; // Example: theme management

  // Global data store
  var userData = {}.obs; // Storing user-related data in a map
  var settings = {}.obs; // Storing app settings
  // Example global variable to store decoded JWT payload
  var decodedToken = <String, dynamic>{}.obs;

  // New Rx variables for _id and userRole
  var userId = ''.obs;
  var userRole = ''.obs;

  // Example functions to manage data
  void updateUsername(String newName) {
    username.value = newName;
  }

  void setLoginStatus(bool status) {
    isLoggedIn.value = status;
  }

  void toggleTheme() {
    appTheme.value = appTheme.value == 'light' ? 'dark' : 'light';
  }

  void saveUserData(Map<String, dynamic> data) {
    userData.value = data;
  }

  Map<String, dynamic> retrieveUserData() {
    return userData.value.cast<String, dynamic>();
  }

  void updateSetting(String key, dynamic value) {
    settings[key] = value;
  }

  dynamic getSetting(String key) {
    return settings[key];
  }

  // Decode JWT function
  Map<String, dynamic> decodeJWT(String token) {
    try {
      // Split the token into its parts
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token');
      }

      // Decode the payload
      final payload = parts[1];
      final normalized =
          base64.normalize(payload); // Normalize the base64 string
      final decodedBytes =
          base64.decode(normalized); // Decode the base64 string
      final decodedString =
          utf8.decode(decodedBytes); // Convert bytes to a UTF-8 string
      final payloadMap = json.decode(decodedString); // Parse JSON string to Map
      // Store the decoded payload
      decodedToken.value = payloadMap;
      log("payload map: $payloadMap");
      // Extract and save _id and userRole into Rx variables
      if (payloadMap.containsKey('_id')) {
        userId.value = payloadMap['_id'] ?? '';
      }
      if (payloadMap.containsKey('userRole')) {
        userRole.value = payloadMap['userRole'] ?? '';
      }
      log(" user id: ${userId.value}");
      log(" user role: ${userRole.value}");
      if (payloadMap is! Map<String, dynamic>) {
        throw Exception('Invalid payload');
      }

      // Store the decoded payload
      decodedToken.value = payloadMap;

      return payloadMap;
    } catch (e) {
      print('Error decoding JWT: $e');
      return {};
    }
  }

    @override
  void onInit() {
    super.onInit();
    // _apiHelper = Get.put(ApiHelperImpl());   // Or Get.lazyPut if needed
  }
}
