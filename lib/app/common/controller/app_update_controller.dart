import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ramadan_tracker/app/constants/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../apis/api_helper.dart';
import '../../apis/api_helper_implementation.dart';

class AppUpdateController extends GetxController {
  // final ApiHelper _apiHelper = Get.find<ApiHelper>();
  
  late final ApiHelper _apiHelper;
        // Add this!
          RxString latestVersion = ''.obs;
  RxString downloadUrl = ''.obs;

   Future<void> checkForUpdate() async {
    try {
      final updateInfo = await _apiHelper.fetchLatestVersion();
      latestVersion.value = updateInfo['version'];
      downloadUrl.value = updateInfo['download_link'];

      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      if (_isUpdateAvailable(currentVersion, latestVersion.value)) {
        showUpdateDialog();
      } else {
        print('✅ App is up-to-date');
      }
    } catch (e) {
      print('❌ Error checking for update: $e');
    }
  }

  bool _isUpdateAvailable(String currentVersion, String latestVersion) {
    return _compareVersions(currentVersion, latestVersion) < 0;
  }

  int _compareVersions(String v1, String v2) {
    List<int> parts1 = v1.split('.').map(int.parse).toList();
    List<int> parts2 = v2.split('.').map(int.parse).toList();
    for (int i = 0; i < parts1.length || i < parts2.length; i++) {
      final part1 = i < parts1.length ? parts1[i] : 0;
      final part2 = i < parts2.length ? parts2[i] : 0;
      if (part1 != part2) {
        return part1.compareTo(part2);
      }
    }
    return 0;
  }
Future<bool> checkForUpdateWithResult() async {
  try {
    final updateInfo = await _apiHelper.fetchLatestVersion();
    latestVersion.value = updateInfo['version'];
    downloadUrl.value = updateInfo['download_link'];

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (_isUpdateAvailable(currentVersion, latestVersion.value)) {
      showUpdateDialog();
      return true; // Update needed, stop further navigation
    }
  } catch (e) {
    print('❌ Error checking for update: $e');
  }
  return false; // No update required
}


void showUpdateDialog() {
  Get.defaultDialog(
    title: '🔔 Update Available',
    titleStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'A new version of the app is available. Please update to continue.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Icon(Icons.system_update, size: 40, color: AppColors.primary),
      ],
    ),
    barrierDismissible: false, // Force user to make a choice
    radius: 8,
    actions: [
      TextButton(
        onPressed: () {
          Get.back();  // Close dialog
        },
        child: Text(
          'Later',
          style: TextStyle(color: Colors.grey[700]),
        ),
      ),
      SizedBox(width: 15.w,),
      ElevatedButton(
        onPressed: () {
          Get.back();  // Close dialog
          downloadAndInstallApk();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text('Update Now',style: TextStyle(color: Colors.white),),
      ),
    ],
  );
}


  Future<void> downloadAndInstallApk() async {
    final apkUrl = downloadUrl.value;
    print('📥 Download URL: $apkUrl');

    // Easiest option - just open the download link in browser
    if (!await GetUtils.isURL(apkUrl)) {
      Get.snackbar('Invalid URL', 'The provided download link is invalid.');
      return;
    }

    await launchDownloadUrl(apkUrl);
  }

  Future<void> launchDownloadUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      Get.snackbar('Failed', 'Could not open download link.');
    }
  }
  @override
  void onInit() {
    super.onInit();
    _apiHelper = Get.put(ApiHelperImpl());   // Or Get.lazyPut if needed
  }
  
}
