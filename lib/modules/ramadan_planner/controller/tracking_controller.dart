import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

import '../../../app/apis/api_helper.dart';
import '../../../app/common/storage/storage_controller.dart';
import '../../../app/translation/translation_keys.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import 'ramadan_planner_controller.dart';

class TrackingController extends GetxController {
  final int ramadanDay;
  final String slug;
  final String type; // "checkbox" or "switch"

  final ApiHelper apiHelper = Get.find<ApiHelper>();
  final LocalStorage storage = LocalStorage('ramadan_tracker');
  final RamadanPlannerController _ramadanController = Get.find();
  // Observables
  var trackingOptions = <dynamic>[].obs;
  var isLoadingOptions = true.obs;
  var loadingStates = <String, bool>{}.obs;
var checkedStates = <String, bool>{}.obs; // ✅ Precomputed states
  // Observables for today's points
  // var todaysPoint = 0.obs;
  var isLoadingPoint = true.obs;
  final DashboardController dashboardController = Get.put(DashboardController());

  TrackingController(
      {required this.ramadanDay, required this.slug, required this.type});
  final ConfettiController confettiController =
      ConfettiController(duration: const Duration(milliseconds: 5));
      var userId = ''.obs;  // Store current userId

  @override
  void onInit() {
    super.onInit();
      loadUserId();

    loadTrackingOptions();
    // fetchTodaysPoint();
  }
Future<void> loadUserId() async {
  userId.value = await StorageHelper.getUserId() ?? '';
}
  /// Loads tracking options using the API helper.
  void loadTrackingOptions({bool isToggling = false}) async {
    if (!isToggling) isLoadingOptions(true);
    final result = await apiHelper.fetchTrackingOptions(slug);
    result.fold(
      (error) {
        isLoadingOptions(false);
      },
      (options) {
        trackingOptions.assignAll(options);
      // Initialize loading & checked states
      checkedStates.clear();
      for (var option in options) {
        loadingStates[option['_id']] = false;
        checkedStates[option['_id']] = isUserCheckedSync(option['users'], 'day$ramadanDay');
      }
        isLoadingOptions(false);
      },
    );
  }

  /// Fetch today's points for the user.
  void fetchTodaysPoint({bool isAddPoint = false}) async {
    if (!isAddPoint) isLoadingPoint(false);
    String userId = await StorageHelper.getUserId() ?? '';
    final result = await apiHelper.fetchTodaysPoint(userId, ramadanDay);
    result.fold(
      (error) {
        if (!isAddPoint) isLoadingPoint(false);
      },
      (points) {
        _ramadanController.todaysPoint.value = points;
        update();
        if (!isAddPoint) isLoadingPoint(false);
      },
    );
  }

  /// Update the user's tracking option.
  Future<void> updateTrackingOption(String optionId, bool newValue) async {
    String userId = await StorageHelper.getUserId() ?? '';

    loadingStates[optionId] = true;
    final result = await apiHelper.updateUserTrackingOption(
        slug, optionId, userId, ramadanDay);
    result.fold(
      (error) {
        loadingStates[optionId] = false;
      },
      (message) {
        loadingStates[optionId] = false;
        // Add slight delay for better visual feedback
        Future.delayed(const Duration(milliseconds: 300), () {
          if (newValue) {
            confettiController.play();
          }
        });
        // After updating, refresh today's points and options.
        fetchTodaysPoint();
        dashboardController.fetchDashboardData();
        loadTrackingOptions(isToggling: true);
      },
    );
  }

  /// Submit points change (add or subtract points) for a given option.
  Future<void> submitPoints(int points) async {
    String userId = await StorageHelper.getUserId() ?? '';

    final result = await apiHelper.addPoints(userId, ramadanDay, points);
    result.fold(
      (error) {
        // Handle error (e.g., show a toast in your view if desired)
      },
      (message) {
        // Trigger confetti when points are added (not when removed)
        if (points > 0) {
          confettiController.play();
        }
        fetchTodaysPoint();
      },
    );
  }

  /// Helper to check if the current user is included in the option's users for this day.
  // bool isUserChecked(List<dynamic> optionUsers, String day) {
  //   String? userId = storage.getItem('_id');
  //   if (userId == null) return false;
  //   // Adjust condition according to your API's structure.
  //   return optionUsers.any((user) =>
  //       (user is String && user == userId) ||
  //       (user is Map && user['user'] == userId && user['day'] == day));
  // }
/// Direct synchronous check (userId is already available)
bool isUserCheckedSync(List<dynamic> optionUsers, String day) {
  if (userId.value.isEmpty) return false;

  return optionUsers.any((user) =>
      user is Map &&
      user.containsKey('user') &&
      user['user'] == userId.value &&
      user['day'] == day);
}
  /// Returns a tracking name based on slug.
  // String getTrackingName() {
  //   switch (slug) {
  //     case 'night_tracking':
  //       return "রাত ট্রাকিং:";
  //     case 'fajr_tracking':
  //       return "ফজর ট্রাকিং";
  //     case 'zuhr_tracking':
  //       return "যোহর ট্রাকিং";
  //     case 'asr_tracking':
  //       return "আসর ট্রাকিং";
  //     case 'afternoon_tracking':
  //       return "বিকেল ট্রাকিং";
  //     case 'qadr_tracking':
  //       return "ক্বদর ট্রাকিং:";
  //     case 'general_tracking':
  //       return "অত্যন্ত প্রয়োজনীয়";
  //     case 'evening_tracking':
  //       return "সন্ধ্যা ট্রাকিং";
  //     default:
  //       return "";
  //   }
  // }
String getTrackingName() {
  switch (slug) {
    case 'night_tracking':
      return TranslationKeys.nightTracking.tr;
    case 'fajr_tracking':
      return TranslationKeys.fajrTracking.tr;
    case 'zuhr_tracking':
      return TranslationKeys.zuhrTracking.tr;
    case 'asr_tracking':
      return TranslationKeys.asrTracking.tr;
    case 'afternoon_tracking':
      return TranslationKeys.afternoonTracking.tr;
    case 'qadr_tracking':
      return TranslationKeys.qadrTracking.tr;
    case 'general_tracking':
      return TranslationKeys.generalTracking.tr;
    case 'evening_tracking':
      return TranslationKeys.eveningTracking.tr;
    default:
      return "";
  }
}

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }
}
