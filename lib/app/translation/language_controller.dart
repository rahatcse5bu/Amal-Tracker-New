import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/storage/storage_controller.dart';

class LanguageController extends GetxController {
  final Rx<Locale?> _appLocale = Rx<Locale?>(null);

  Locale? get appLocale => _appLocale.value;

  Future<void> loadLocale() async {
    final languageCode = await StorageHelper.getLanguageCode();
    final countryCode = await StorageHelper.getCountryCode();
    if (languageCode != null && countryCode != null) {
      _appLocale.value = Locale(languageCode, countryCode);
    } else {
      _appLocale.value = const Locale('bn', 'BD'); // Default if no saved language
    }
    Get.updateLocale(_appLocale.value!);
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    await StorageHelper.setLanguage(languageCode, countryCode);
    _appLocale.value = Locale(languageCode, countryCode);
    Get.updateLocale(_appLocale.value!);
    update(); // Force UI update if needed
  }
}
