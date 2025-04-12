import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingOverviewController extends GetxController {
  var isLoading = true.obs;
  var trackingItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTrackingItems();
  }

  void loadTrackingItems() {
    // Simulate loading tracking items
    Future.delayed(const Duration(seconds: 1), () {
      trackingItems.value = [
        {'slug': 'fajr_tracking', 'title': 'Fajr Tracking', 'icon': Icons.wb_sunny},
        {'slug': 'zuhr_tracking', 'title': 'Zuhr Tracking', 'icon': Icons.wb_sunny_outlined},
        {'slug': 'asr_tracking', 'title': 'Asr Tracking', 'icon': Icons.cloud},
        {'slug': 'evening_tracking', 'title': 'Evening Tracking', 'icon': Icons.nightlight_round},
        {'slug': 'night_tracking', 'title': 'Night Tracking', 'icon': Icons.brightness_3},
        {'slug': 'qadr_tracking', 'title': 'Qadr Tracking', 'icon': Icons.star},
      ];
      isLoading.value = false;
    });
  }
}
