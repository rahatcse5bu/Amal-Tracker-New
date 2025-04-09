import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:ramadan_tracker/modules/dus-list/models/dua_model.dart';

import '../../modules/borjoniyo/models/borjoniyo_model.dart';
import '../../modules/dashboard/models/user_model.dart';
import '../../modules/koroniyo/models/koroniyo_model.dart';
import '../../modules/login/models/login_request_model.dart'
    show LoginRequestModel;
import '../../modules/login/models/login_response_model.dart';
import '../../modules/ramadan_planner/models/ayat_model.dart';
import '../../modules/register/models/register_model.dart';
import '../common/models/ayat_model.dart';
import '../common/models/hadith_model.dart';
import '../common/models/salaf_quotes_model.dart';
import 'custom_error.dart';

abstract class ApiHelper {
  // Future<Either<CustomError, LoginResponse>> login(LoginRequestModel login);
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload);

  Future<Either<CustomError, Response>> register(RegisterRequestModel register);
  Future<Either<CustomError, String>> fetchAjkerAyat();
  Future<Either<CustomError, List<AyatModel>>> fetchAyat();
Future<Either<CustomError, List<AjkerHadithModel>>> fetchAjkerHadith();
  Future<Either<CustomError, String>> fetchAjkerSalafQuote();
  Future<Either<CustomError, List<SalafQuoteModel>>> fetchSalafQuotes();
  Future<Either<CustomError, Map<String, dynamic>>> fetchAjkerDua();
    Future<Either<CustomError, List<DuaModel>>> fetchDua();
  Future<Either<CustomError, String>> addInputValueForUser(
      int ramadanDay, String value);
  Future<Either<CustomError, String>> updateUserTrackingOption(
      String slug, String optionId, String userId, int ramadanDay);
  Future<Either<CustomError, String>> addPoints(
      String userId, int ramadanDay, int points);
  Future<Either<CustomError, List<dynamic>>> fetchTrackingOptions(String slug);
  Future<Either<CustomError, List<UserModel>>> fetchUsers();
  Future<Either<CustomError, int>> fetchTodaysPoint(
      String userId, int ramadanDay);
  // Future<Either<CustomError, Map<String, dynamic>>> fetchUserRanking();
  Future<Either<CustomError, Map<String, dynamic>>> fetchCurrentUserPoints();
  Future<Either<CustomError, Map<String, dynamic>>>
      fetchCurrentUserRankAndPoints(String userId);
  Future<Either<CustomError, List<KoroniyoModel>>> fetchKoroniyo();
   Future<Either<CustomError, List<BorjoniyoModel>>> fetchBorjoniyo();
  Future<Map<String, dynamic>> fetchLatestVersion();
}
