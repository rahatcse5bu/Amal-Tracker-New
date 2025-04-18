import 'dart:developer';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

import '../../../app/apis/api_helper.dart';
import '../../../app/common/storage/storage_controller.dart';
import '../../../app/translation/translation_keys.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../models/tracking_options_model.dart';
import 'amal_tracker_controller.dart';

class TrackingController extends GetxController {
  final int ramadanDay;
  final String slug;
  final String type; // "checkbox" or "switch"

  final ApiHelper apiHelper = Get.find<ApiHelper>();
  final LocalStorage storage = LocalStorage('amal_tracker');
  final RamadanPlannerController _ramadanController = Get.find();
  final RxList<TrackingOption> trackingOptions = <TrackingOption>[].obs;
  var isLoadingOptions = true.obs;
  var loadingStates = <String, bool>{}.obs;
  var checkedStates = <String, bool>{}.obs; // ✅ Precomputed states
  var isLoadingPoint = true.obs;
  final DashboardController dashboardController = Get.put(DashboardController());

  TrackingController(
      {required this.ramadanDay, required this.slug, required this.type});
  final ConfettiController confettiController =
      ConfettiController(duration: const Duration(milliseconds: 5));
  var userId = ''.obs;  // Store current userId
  final Map<String, bool> optionInMosque = {};
  final Map<String, bool> optionKhushuKhuzu = {};
  final Map<String, bool> optionQadha = {};
  final Map<String, bool> optionRegularOrder = {};
  final Map<String, bool> optionInJamayat = {};
  final Map<String, int> optionKhushuLevel = {};
  final Map<String, int> currentProgress = {};
  final Map<String, bool> optionHayez = {};
  final Map<String, bool> optionQasr = {};

  @override
  void onInit() {
    super.onInit();
    loadUserId();
    loadTrackingOptions();
  }

  void toggleOptionProperty(String optionId, String property, bool value) {
    // Update only the specific property
    switch (property) {
      case 'isInMosque':
        optionInMosque[optionId] = value;
        break;
      case 'isKhushuKhuzu':
        optionKhushuKhuzu[optionId] = value;
        break;
      case 'isQadha':
        optionQadha[optionId] = value;
        break;
      case 'isRegularOrder':
        optionRegularOrder[optionId] = value;
        break;
      case 'isInJamayat':
        optionInJamayat[optionId] = value;
        break;
      case 'isHayez':
        optionHayez[optionId] = value;
        break;
      case 'isQasr':
        optionQasr[optionId] = value;
        break;
    }

    // Prepare the payload with the updated property and retain other properties
    final payload = {
      "isInMosque": optionInMosque[optionId] ?? false,
      "isKhushuKhuzu": optionKhushuKhuzu[optionId] ?? false,
      "isQadha": optionQadha[optionId] ?? false,
      "isRegularOrder": optionRegularOrder[optionId] ?? false,
      "khushuLevel": optionKhushuLevel[optionId],
      "isInJamayat": optionInJamayat[optionId] ?? false,
      "isSalatTracking": trackingOptions.firstWhereOrNull((o) => o.id == optionId)?.isSalatTracking ?? false,
      "isHayez": optionHayez[optionId] ?? false,
      "isQasr": optionQasr[optionId] ?? false,
      "totalCount": currentProgress[optionId] ?? 0,
      "totalPoint": calculateTotalPoint(optionId),
    };

    // Log the payload only once
    log("new payload: ${payload}");

    // Call updateTrackingOption only once
    updateTrackingOption(optionId, true);
  }

  int calculateTotalPoint(String optionId) {
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null || option.milestone <= 0) return 0;

    final totalCount = currentProgress[optionId] ?? 0;
    return ((totalCount / option.milestone) * option.point).toInt();
  }

  void updateKhushuLevel(String optionId, int level) {
    optionKhushuLevel[optionId] = level.clamp(1, 5);
    update();
    updateTrackingOption(optionId, true); // Trigger update with new values
  }

  void incrementOptionCount(String optionId) {
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null) return;
    
    final maxCount = option.milestone > 0 ? option.milestone : 100;
    currentProgress[optionId] = ((currentProgress[optionId] ?? 0) + 1).clamp(0, maxCount);
    update();
    updateTrackingOption(optionId, true); // Trigger update with new values
  }

  void decrementOptionCount(String optionId) {
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null) return;
    
    final maxCount = option.milestone > 0 ? option.milestone : 100;
    currentProgress[optionId] = ((currentProgress[optionId] ?? 0) - 1).clamp(0, maxCount);
    update();
    updateTrackingOption(optionId, true); // Trigger update with new values
  }

  void updateOptionCount(String optionId, int value) {
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null) return;
    
    final maxCount = option.milestone > 0 ? option.milestone : 100;
    currentProgress[optionId] = value.clamp(0, maxCount);
    update();
  }

  Future<void> loadUserId() async {
    userId.value = await StorageHelper.getUserId() ?? '';
  }

  void loadTrackingOptions({bool isToggling = false}) async {
    try {
      if (!isToggling) isLoadingOptions(true);

      final result = await apiHelper.fetchTrackingOptions(slug);
      result.fold(
        (error) {
          print("Error: $error");
          isLoadingOptions(false);
        },
        (options) {
          print("Loaded ${options.length} options");
          
          // Clear all state maps
          checkedStates.clear();
          loadingStates.clear();
          optionInMosque.clear();
          optionKhushuKhuzu.clear();
          optionQadha.clear();
          optionRegularOrder.clear();
          optionInJamayat.clear();
          optionKhushuLevel.clear();
          optionHayez.clear();
          optionQasr.clear();
          currentProgress.clear();

          // First, initialize all options with default values
          for (var option in options) {
            loadingStates[option.id] = false;
            checkedStates[option.id] = false;
            optionInMosque[option.id] = false;
            optionKhushuKhuzu[option.id] = false;
            optionQadha[option.id] = false;
            optionRegularOrder[option.id] = false;
            optionInJamayat[option.id] = false;
            optionKhushuLevel[option.id] = 0;
            optionHayez[option.id] = false;
            optionQasr[option.id] = false;
            currentProgress[option.id] = 0;
          }

          // Then update user-specific data
          for (var option in options) {
            // Find matching user entry by user ID and day
            final userEntry = option.users.firstWhereOrNull(
              (entry) => entry.id == userId.value && entry.day == 'day$ramadanDay',
            );

            if (userEntry != null) {
              checkedStates[option.id] = true;
              // Use the values from userEntry instead of option
              optionInMosque[option.id] = userEntry.isInMosque is bool
                  ? userEntry.isInMosque
                  : userEntry.isInMosque == 'true';
              optionKhushuKhuzu[option.id] = userEntry.isKhushuKhuzu is bool
                  ? userEntry.isKhushuKhuzu
                  : userEntry.isKhushuKhuzu == 'true';
              optionQadha[option.id] = userEntry.isQadha is bool
                  ? userEntry.isQadha
                  : userEntry.isQadha == 'true';
              optionRegularOrder[option.id] = userEntry.isRegularOrder is bool
                  ? userEntry.isRegularOrder
                  : userEntry.isRegularOrder == 'true';
              optionInJamayat[option.id] = userEntry.isInJamayat is bool
                  ? userEntry.isInJamayat
                  : userEntry.isInJamayat == 'true';
              optionKhushuLevel[option.id] = userEntry.khushuLevel ?? 0;
              optionHayez[option.id] = userEntry.isHayez is bool
                  ? userEntry.isHayez
                  : userEntry.isHayez == 'true';
              optionQasr[option.id] = userEntry.isQasr is bool
                  ? userEntry.isQasr
                  : userEntry.isQasr == 'true';
              currentProgress[option.id] = userEntry.totalCount;
            }
          }

          trackingOptions.assignAll(options);
          isLoadingOptions(false);
        },
      );
    } catch (error) {
      print("Error: $error");
    }
  }

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

  Future<void> updateTrackingOption(String optionId, bool newValue) async {
    String userId = await StorageHelper.getUserId() ?? '';
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null) return;

    loadingStates[optionId] = true;

    // Calculate totalPoint based on totalCount and milestone
    final int totalCount = currentProgress[optionId] ?? 0;
    final int totalPoint = option.milestone > 0
        ? ((totalCount / option.milestone) * option.point).toInt()
        : 0;

    // Prepare the payload
    final payload = {
      "isInMosque": optionInMosque[optionId] ?? false,
      "isKhushuKhuzu": optionKhushuKhuzu[optionId] ?? false,
      "isQadha": optionQadha[optionId] ?? false,
      "isRegularOrder": optionRegularOrder[optionId] ?? false,
      "khushuLevel": optionKhushuLevel[optionId],
      "isInJamayat": optionInJamayat[optionId] ?? false,
      "isSalatTracking": option.isSalatTracking,
      "isHayez": optionHayez[optionId] ?? false,
      "isQasr": optionQasr[optionId] ?? false,
      "totalCount": totalCount,
      "totalPoint": totalPoint,
    };

    // Log the payload only once
    log("new payload: ${payload}");

    final result = await apiHelper.updateUserTrackingOption(
      slug,
      optionId,
      userId,
      ramadanDay,
      payload,
    );

    result.fold(
      (error) {
        loadingStates[optionId] = false;
        log("Error: ${error}");
      },
      (message) {
        log("Message: ${message}");
        loadingStates[optionId] = false;

        // Update the local state directly
        if (newValue && (message == "Update successful" || message.isNotEmpty)) {
          checkedStates[optionId] = true;
          confettiController.play();
        }

        // Safely update the specific option in the reactive state
        final optionIndex = trackingOptions.indexWhere((o) => o.id == optionId);
        if (optionIndex != -1) {
          trackingOptions[optionIndex] = trackingOptions[optionIndex].copyWith(
            totalCount: totalCount,
            totalPoint: totalPoint,
          );
          trackingOptions.refresh(); // Ensure UI updates
        }

        fetchTodaysPoint();
        dashboardController.fetchDashboardData();
      },
    );
  }

  Future<void> submitPoints(int points) async {
    String userId = await StorageHelper.getUserId() ?? '';

    final result = await apiHelper.addPoints(userId, ramadanDay, points);
    result.fold(
      (error) {
        // Handle error (e.g., show a toast in your view if desired)
      },
      (message) {
        if (points > 0) {
          confettiController.play();
        }
        fetchTodaysPoint();
      },
    );
  }

  bool isUserCheckedSync(List<dynamic> optionUsers, String day) {
    if (userId.value.isEmpty) return false;

    return optionUsers.any((user) =>
        user is Map &&
        user.containsKey('user') &&
        user['user'] == userId.value &&
        user['day'] == day);
  }

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

  int getAverageCompletionTime() {
    if (trackingOptions.isEmpty) return 0;
    
    final completedOptions = trackingOptions.where((option) => checkedStates[option.id] == true).length;
    if (completedOptions == 0) return 0;
    
    return trackingOptions.fold(0, (sum, option) => 
      sum + (checkedStates[option.id] == true ? 10 : 0)) ~/ completedOptions;
  }

  bool isMilestoneCompleted(String optionId) {
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null || option.milestone <= 0) return false;
    return (currentProgress[optionId] as int? ?? 0) >= option.milestone;
  }

  int getTotalCount() => trackingOptions.fold(0, (sum, option) => sum + option.totalCount);

  int getMaxCount() => 100;

  int getCurrentProgress(String optionId) {
    return currentProgress[optionId] ?? 0;
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }
}

// Add a helper method to copy and update TrackingOption
extension TrackingOptionExtensions on TrackingOption {
  TrackingOption copyWith({
    int? totalCount,
    int? totalPoint,
  }) {
    return TrackingOption(
      id: id,
      title: title,
      description: description,
      point: point,
      index: index,
      milestone: milestone,
      totalCount: totalCount ?? this.totalCount,
      isInMosque: isInMosque,
      isKhushuKhuzu: isKhushuKhuzu,
      isQadha: isQadha,
      isRegularOrder: isRegularOrder,
      isInJamayat: isInJamayat,
      khushuLevel: khushuLevel,
      isCountable: isCountable,
      isSalatTracking: isSalatTracking,
      isHayez: isHayez,
      isQasr: isQasr,
      users: users,
      enTitle: enTitle,
      enDescription: enDescription,
      arTitle: arTitle,
      arabic: arabic,
      arDescription: arDescription,
      descriptionEn: descriptionEn,
    );
  }
}
