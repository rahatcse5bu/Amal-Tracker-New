import 'dart:developer';

import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../app/apis/api_helper.dart';
import '../../../app/common/models/ayat_model.dart';
import '../../../app/common/models/hadith_model.dart';
import '../../../app/common/models/salaf_quotes_model.dart';
import '../../../app/common/storage/storage_controller.dart';
import '../../../app/common/utils/ramadan_utils.dart';
import '../models/user_model.dart';

class DashboardController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  // final Random _random = Random();
  var totalPoints = 0.obs;
  var userRank = 0.obs;
  var isLoading = true.obs;
  // var isLoadingAjkerAyat = true.obs;
  var users = <UserModel>[].obs;
  List<int> ramadanList = List.generate(30, (index) => index + 1).obs;
  // var ajkerAyat = ''.obs;
  // var ajkerHadith = ''.obs;
  var ajkerSalafQuote = ''.obs;
  var salafQuotes = <SalafQuoteModel>[].obs;
  var HadithList = <AjkerHadithModel >[].obs;
  var AyatList = <AyatModel >[].obs;

  var current_month = HijriCalendar.now().getLongMonthName();
  var current_date = HijriCalendar.now().hDay;
  // final _random = new Random();
  var username =''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    fetchLocalData();
  }

  Future<void> fetchLocalData() async {
username.value=await Utils. getUserName()??'';
  }
  Future<void> fetchDashboardData() async {
    isLoading(true);
    await fetchAjkerAyat();
    await fetchAjkerHadith();
    await fetchAjkerSalafQuote();
    await fetchUsers();
    await fetchCurrentUserPoints();
    isLoading(false);
  }

  Future<void> fetchAjkerAyat() async {
    final result = await _apiHelper.fetchAyat();
    result.fold((error) => null, (ayat) => AyatList.value = ayat);
    log("ajker ayat: " + AyatList.first.enText);
  }

  Future<void> fetchAjkerHadith() async {
    final result = await _apiHelper.fetchAjkerHadith();
    result.fold((error) => null, (hadith) => HadithList.value = hadith);
    log("ajker ayat: " + HadithList.value.first.enText);
  }

  Future<void> fetchAjkerSalafQuote() async {
    final result = await _apiHelper.fetchSalafQuotes();
    result.fold((error) => null, (quote) => salafQuotes.value = quote);
    log("ajker ayat: " + salafQuotes.first.bnText);
    log("ajker ayat: " + salafQuotes.first.enText);
  }

  Future<void> fetchUsers() async {
    final result = await _apiHelper.fetchUsers();
    result.fold(
      (error) => null, // Handle error case if needed
      (userList) async {
        final String? currentUser =
            await StorageHelper.getUserName(); // Get logged-in user
        users.value = userList; // Assign full user list
              // Sort users based on totalPoints (descending - highest points first)
      users.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));


  log("userrrr: ${users.value.first.fullName}");
        // Find the logged-in user's totalPoints
        totalPoints.value = userList
            .firstWhere((user) => user.userName == currentUser,
                orElse: () => UserModel(
                    totalPoints: 0,
                    userName: '',
                    fullName: '') // Default if user not found
                )
            .totalPoints;
      },
    );
  }

  Future<void> fetchCurrentUserPoints() async {
    isLoading.value = true;
    final String? userId =
        await StorageHelper.getUserId(); // Get user ID safely

    final result = await _apiHelper.fetchCurrentUserRankAndPoints(userId ?? '');
    result.fold(
      (error) {
        isLoading.value = false;
        totalPoints.value = 0;
        userRank.value = 0;
      },
      (data) {
        totalPoints.value = data['totalPoints'];
        userRank.value = data['rank'];
        isLoading.value = false;
      },
    );
  }

  Future<void> logout() async {
    await StorageHelper.removeUserName();
    await StorageHelper.removeToken();
    await StorageHelper.removeUserData();
    await StorageHelper.removeFullName();
    Get.offAllNamed('/login');
  }
}
