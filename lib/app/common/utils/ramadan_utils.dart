import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../APIs/api_helper.dart';
import '../../APIs/api_helper_implementation.dart';
import '../../common/controller/app_controller.dart';
import '../../constants/app_color.dart';
import '../storage/storage_controller.dart';

class Utils {
  static Future<void> logoutUser() async {
    try {
      // Get AppController instance
      final AppController appController = getAppController();

      // Clear reactive variables in AppController
      appController.userId.value = '';
      appController.username.value = '';
      appController.userRole.value = '';
      appController.isLoggedIn.value = false;
      appController.userData.value = {};
      appController.decodedToken.value = {};

      // Clear SharedPreferences
      await StorageHelper.removeToken();
      await StorageHelper.removeUserData();
      await StorageHelper.removeUserId();

      // Navigate to login or splash screen
      Get.offAllNamed(
          '/login'); // Replace '/login' with your actual login route
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  static void showSnackbar({
    required String message,
    String title = 'Notice',
    Color backgroundColor = AppColors.primary, // Default color
    Color textColor = Colors.white, // Default color
    SnackPosition position = SnackPosition.TOP, // Default position
    bool isSuccess = true, // Default icon state
    Duration duration = const Duration(seconds: 3), // Default duration
    IconData? icon, // Optional custom icon
  }) {
    Get.snackbar(
      title, // Title of the Snackbar
      message, // Message content
      backgroundColor: backgroundColor,
      colorText: textColor, // Text color
      snackPosition: position,
      icon: Icon(
        icon ??
            (isSuccess
                ? Icons.check_circle
                : Icons.error), // Default icon based on `isSuccess`
        color: Colors.white,
      ),
      duration: duration, // Duration of the Snackbar
      margin: const EdgeInsets.all(10), // Margin around the Snackbar
      borderRadius: 8, // Rounded corners
    );
  }

  static AppController getAppController() {
    return Get.isRegistered<AppController>()
        ? Get.find<AppController>()
        : Get.put(AppController());
  }

  static ApiHelper getApiHelperController() {
    return Get.isRegistered<ApiHelper>()
        ? Get.find<ApiHelper>()
        : Get.put(ApiHelperImpl());
  }



  /// Formats a [DateTime] into "সোমবার, ২২ ডিসেম্বর, ২৪  10:00 AM" format
  static String formatDateToBangla(DateTime date) {
    final DateFormat formatter =
        DateFormat('EEEE, dd MMMM, yy hh:mm a', 'bn_BD');
    return formatter.format(date);
  }

  static String formatDateToBanglaDDM(DateTime date) {
    List<String> bengaliMonths = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];

    String day = convertNumberToBengali(date.day);
    String month = bengaliMonths[date.month - 1];

    return '$day $month';
  }

  static String convertNumberToBengali(int number) {
    List<String> bengaliDigits = [
      '০',
      '১',
      '২',
      '৩',
      '৪',
      '৫',
      '৬',
      '৭',
      '৮',
      '৯'
    ];

    String numberString = number.toString();
    StringBuffer bengaliNumber = StringBuffer();

    for (int i = 0; i < numberString.length; i++) {
      int digit = int.parse(numberString[i]);
      bengaliNumber.write(bengaliDigits[digit]);
    }

    return bengaliNumber.toString();
  }

    Future<String> _loadCurrentLanguage() async {
 
  
      return await StorageHelper.getLanguageCode()??'';
   
  }

  Future<void> _changeLanguage(String? languageCode) async {
    if (languageCode == null) return;


    String countryCode;

    switch (languageCode) {
      case 'bn':
        countryCode = 'BD';
        break;
      case 'en':
      default:
        countryCode = 'US';
        break;
    }

    await StorageHelper.setLanguage(languageCode, countryCode);
    
    Get.updateLocale(Locale(languageCode, countryCode));
    
  
  }
static Future<String?> getUserName() async {
  return StorageHelper.getUserName();
}
static String getNumberSuffix(int number) {
  if (number >= 11 && number <= 13) {
    return 'th'; // Special case for 11th, 12th, 13th
  }
  
  switch (number % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

}
