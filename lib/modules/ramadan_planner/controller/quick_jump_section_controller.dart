import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickJumpSectionController extends GetxController {
  final ScrollController scrollController = ScrollController();
    var showBackToTop = true.obs; // Controls visibility of the widget
    var showGrid = false.obs; // Controls visibility of the widget

  // final Map<String, GlobalKey> sectionKeys = {
  //   'maghrib': GlobalKey(),
  //   'qadr': GlobalKey(),
  //   'fajr': GlobalKey(),
  //   'zuhr': GlobalKey(),
  //   'common': GlobalKey(),
  //   'other': GlobalKey(),
  //   'asr': GlobalKey(),
  //   'night': GlobalKey(),
  //   'special': GlobalKey(),
  // };
final Map<String, Map<String, dynamic>> sectionKeys = {
  'maghrib': {'key': GlobalKey(), 'bnTitle': 'মাগরিব'},
  'qadr': {'key': GlobalKey(), 'bnTitle': 'কদর'},
  'fajr': {'key': GlobalKey(), 'bnTitle': 'ফজর'},
  'zuhr': {'key': GlobalKey(), 'bnTitle': 'জুহর'},
  'common': {'key': GlobalKey(), 'bnTitle': 'সাধারণ'},
  'other': {'key': GlobalKey(), 'bnTitle': 'অন্যান্য'},
  'asr': {'key': GlobalKey(), 'bnTitle': 'আসর'},
  'night': {'key': GlobalKey(), 'bnTitle': 'রাত'},
  'special': {'key': GlobalKey(), 'bnTitle': 'বিশেষ'},
};

  // void scrollToSection(String section) {
  //   final key = sectionKeys[section];
  //   if (key?.currentContext != null) {
  //     Scrollable.ensureVisible(
  //       key!.currentContext!,
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

void scrollToSection(String section) {
  final sectionData = sectionKeys[section]; // Access the stored map
  final GlobalKey? key = sectionData?['key']; // Extract the key

  if (key != null && key.currentContext != null) {
    debugPrint("📌 Scrolling to section: ${sectionData?['bnTitle']}");
    Future.delayed(Duration(milliseconds: 100), () {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  } else {
    debugPrint("❌ Section key not found or not attached: $section");
  }
}

  void _scrollListener() {
    double currentPosition = scrollController.position.pixels;
    double deviceHeight = Get.height;

    // Show widget if scrolled past device height
    showBackToTop.value = currentPosition > deviceHeight;
  }

  void scrollToTop() {
    scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }


}
