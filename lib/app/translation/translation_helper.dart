// Example of how to change language anywhere in the app
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> changeLanguage(String languageCode, String countryCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('languageCode', languageCode);
  await prefs.setString('countryCode', countryCode);
  Get.updateLocale(Locale(languageCode, countryCode));
}

// Usage example:
// To change to Bengali:
// await changeLanguage('bn', 'BD');
// To change to English:
// await changeLanguage('en', 'US');