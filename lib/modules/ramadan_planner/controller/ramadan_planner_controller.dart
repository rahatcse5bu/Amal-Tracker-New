import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hijri/hijri_calendar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ramadan_tracker/app/common/storage/storage_controller.dart';

import '../../../app/apis/api_helper.dart';
import '../../../app/common/models/ayat_model.dart';
import '../../../app/common/models/hadith_model.dart';
import '../models/ayat_model.dart';

class RamadanPlannerController extends GetxController {
  // Storage and API calls can also be abstracted via an ApiHelper.
  final LocalStorage storage = LocalStorage('ramadan_tracker');

  // Observables for data
  // var ajkerHadith = ''.obs;
  var HadithList = <AjkerHadithModel >[].obs;
  var ajkerDuaTitle = ''.obs;
  var ajkerDuaBangla = ''.obs;
  var ajkerDuaArabic = ''.obs;
  var ajkerAyat = <AyatModel>[].obs;
  var todaysPoint = 0.obs;

  // Loading states
  var isLoadingHadith = true.obs;
  var isLoadingDua = true.obs;
  var isLoadingAyat = true.obs;
  var isLoadingPoint = true.obs;

  // Text editing for special achievements
  TextEditingController specialAchievementController = TextEditingController();
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  // Other state variables
  var currentMonth = HijriCalendar.now().getLongMonthName();
  var currentDate = HijriCalendar.now().hDay;
  var currentYear = HijriCalendar.now().hYear.obs;
  var startName = 0.obs;
  var endName = 0.obs;
  RxString ramadan_date_key = ''.obs;
  // final Random _random = Random();
  late var ramadanDay;
  @override
  Future<void> onInit() async {
    super.onInit();
    // Assume ramadan_day is passed as an argument (e.g., via Get.arguments)
    ramadanDay = Get.arguments['ramadan_day'] ?? 1;
    ramadan_date_key.value = "ramadan_${ramadanDay}_${currentYear}";
    // Initialize special achievement controller with stored value (if any)
    String initialValue =
        await StorageHelper.getSpecialAchievement(ramadan_date_key.value) ?? '';
    // specialAchievementController = TextEditingController(text: initialValue);
    specialAchievementController.text = initialValue;
    // **Trigger UI update**
    update();
    // Calculate indices for Asmaul Husna table
    endName.value = ramadanDay * 3;
    startName.value = (endName.value - 3) ;
    log("start: ${startName}");
    log("end: ${endName}");
    // Fetch API data
    // Fetch all necessary data.
    fetchAllData();
  }

  void fetchAllData() {
    fetchAjkerHadith();
    // fetchAjkerAyat();
    fetchAyat();
    fetchAjkerDua();
    fetchTodaysPoint();
  }

  /// Fetch today's Hadith via API helper.
  void fetchAjkerHadith() async {
    final result = await _apiHelper.fetchAjkerHadith();
    result.fold(
      (error) {
        isLoadingHadith(false);
        // Optionally handle error here.
      },
      (hadithText) {
        HadithList.value = hadithText;
        isLoadingHadith(false);
      },
    );
  }

  /// Fetch today's Ayat via API helper.
  // void fetchAjkerAyat() async {
  //   final result = await _apiHelper.fetchAjkerAyat();
  //   result.fold(
  //     (error) {
  //       isLoadingAyat(false);
  //     },
  //     (ayatText) {
  //       ajkerAyat.value = ayatText;
  //       isLoadingAyat(false);
  //     },
  //   );
  // }
  /// Fetch today's Ayat via API helper.
  void fetchAyat() async {
    final result = await _apiHelper.fetchAyat();
    result.fold(
      (error) {
        isLoadingAyat(false);
      },
      (ayatText) {
        ajkerAyat.value = ayatText;
        isLoadingAyat(false);
      },
    );
  }
  /// Fetch today's Dua via API helper.
  void fetchAjkerDua() async {
    final result = await _apiHelper.fetchAjkerDua();
    result.fold(
      (error) {
        isLoadingDua(false);
      },
      (duaData) {
        ajkerDuaTitle.value = duaData['title'] ?? '';
        ajkerDuaBangla.value = duaData['bangla'] ?? '';
        ajkerDuaArabic.value = duaData['arabic'] ?? '';
        isLoadingDua(false);
      },
    );
  }

  /// Fetch today's points for the user via API helper.
  void fetchTodaysPoint() async {
    String userId = await StorageHelper.getUserId() ?? '';
    final result = await _apiHelper.fetchTodaysPoint(userId, ramadanDay);
    result.fold(
      (error) {
        isLoadingPoint(false);
      },
      (points) {
        todaysPoint.value = points;
        isLoadingPoint(false);
      },
    );
  }

  // Future<void> addInputValueForUser(int ramadanDay) async {
  //   await storage.ready;
  //   String userId = storage.getItem('_id') ?? '';
  //   final Uri apiUri = Uri.parse(
  //       'https://ramadan-tracker-server.vercel.app/api/v1/users/add-values/$userId');
  //   final response = await http.post(
  //     apiUri,
  //     headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //     body: jsonEncode({
  //       'day': ramadanDay.toString(),
  //       'value': specialAchievementController.text,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     Fluttertoast.showToast(msg: "Value added successfully");
  //   } else {
  //     Fluttertoast.showToast(msg: "Failed to add value. Please try again.");
  //   }
  // }

  void saveAchievement(String? ramadanDay) {
    StorageHelper.addSpecialAchievement(
        specialAchievementController.text, ramadan_date_key.value);
    Fluttertoast.showToast(
      msg: "আপনার তথ্য সংরক্ষণ করা হয়েছে",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
