import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';

import '../../../app/apis/api_helper.dart';
import '../../../app/common/storage/storage_controller.dart';
import '../../../app/translation/translation_keys.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../models/tracking_options_model.dart';
import 'ramadan_planner_controller.dart';

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

  @override
  void onInit() {
    super.onInit();
    loadUserId();
    loadTrackingOptions();
  }

  void toggleOptionProperty(String optionId, String property, bool value) {
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
    }
    updateTrackingOption(optionId, true); // Update on server
  }

  void updateKhushuLevel(String optionId, int level) {
    optionKhushuLevel[optionId] = level.clamp(1, 5);
    updateTrackingOption(optionId, true);
  }

  void incrementOptionCount(String optionId) {
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null) return;
    
    final maxCount = option.milestone > 0 ? option.milestone : 100;
    currentProgress[optionId] = ((currentProgress[optionId] ?? 0) + 1).clamp(0, maxCount);
    update();
  }

  void decrementOptionCount(String optionId) {
    final option = trackingOptions.firstWhereOrNull((o) => o.id == optionId);
    if (option == null) return;
    
    final maxCount = option.milestone > 0 ? option.milestone : 100;
    currentProgress[optionId] = ((currentProgress[optionId] ?? 0) - 1).clamp(0, maxCount);
    update();
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
    if (!isToggling) isLoadingOptions(true);

    final result = await apiHelper.fetchTrackingOptions(slug);
    result.fold(
      (error) => isLoadingOptions(false),
      (options) {
        trackingOptions.assignAll(options);
        checkedStates.clear();
        loadingStates.clear();

        optionInMosque.clear();
        optionKhushuKhuzu.clear();
        optionQadha.clear();
        optionRegularOrder.clear();
        optionInJamayat.clear();
        optionKhushuLevel.clear();

        for (var option in options) {
          final userMatched = option.users.firstWhereOrNull(
            (u) => u.user == userId.value && u.day == 'day$ramadanDay',
          );

          final bool isChecked = userMatched != null;
          checkedStates[option.id] = isChecked;
          loadingStates[option.id] = false;

          if (isChecked) {
            optionInMosque[option.id] = option.isInMosque;
            optionKhushuKhuzu[option.id] = option.isKhushuKhuzu;
            optionQadha[option.id] = option.isQadha;
            optionRegularOrder[option.id] = option.isRegularOrder;
            optionInJamayat[option.id] = option.isInJamayat;
            optionKhushuLevel[option.id] = option.khushuLevel;
          }

          currentProgress[option.id] = option.totalCount;
        }

        isLoadingOptions(false);
      },
    );
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

    loadingStates[optionId] = true;
    final result = await apiHelper.updateUserTrackingOption(
        slug, optionId, userId, ramadanDay);
    result.fold(
      (error) {
        loadingStates[optionId] = false;
      },
      (message) {
        loadingStates[optionId] = false;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (newValue) {
            confettiController.play();
          }
        });
        fetchTodaysPoint();
        dashboardController.fetchDashboardData();
        loadTrackingOptions(isToggling: true);
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
    return trackingOptions.fold(0, (sum, option) => 
      sum + (checkedStates[option.id] == true ? 10 : 0)) ~/ 
      trackingOptions.where((option) => checkedStates[option.id] == true).length;
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
