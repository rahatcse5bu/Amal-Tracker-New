import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' show min;
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/connect.dart';
import 'package:http/http.dart' as http;
import 'package:amal_tracker/modules/dus-list/models/dua_model.dart';
import '../../modules/amal_tracker/models/tracking_options_model.dart';
import '../../modules/borjoniyo/models/borjoniyo_model.dart';
import '../../modules/dashboard/models/user_model.dart';
import '../../modules/koroniyo/models/koroniyo_model.dart';
import '../../modules/login/models/login_request_model.dart';
import '../../modules/login/models/login_response_model.dart';
import '../../modules/register/models/register_model.dart';
import '../common/models/ayat_model.dart';
import '../common/models/hadith_model.dart';
import '../common/models/salaf_quotes_model.dart';
import '../common/storage/storage_controller.dart' show StorageHelper;
import '../constants/app_config.dart';
import 'api_helper.dart';
import 'custom_error.dart';

class ApiHelperImpl extends GetConnect implements ApiHelper {
  @override
  void onInit() {
    super.onInit();

    log("🚀 API_INIT: BaseUrl = ${AppConfig.baseUrl}${AppConfig.apiVersion}/");
    log("⏱️  Timeout = ${AppConfig.timeoutDuration} seconds");
    httpClient.baseUrl = '${AppConfig.baseUrl}${AppConfig.apiVersion}/';
    httpClient.timeout = const Duration(seconds: AppConfig.timeoutDuration);
    httpClient.defaultContentType = 'application/json';

    httpClient.addRequestModifier<Object?>((request) async {
      final token = await StorageHelper.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      log('═══════════════════════════════════════════════════════════');
      log('📤 API_REQUEST');
      log('Method: ${request.method}');
      log('URL: ${request.url}');
      log('Headers: ${request.headers}');
      log('═══════════════════════════════════════════════════════════');
      return request;
    });

    httpClient.addResponseModifier<Object?>((request, response) {
      try {
        log('═══════════════════════════════════════════════════════════');
        log('📥 API_RESPONSE');
        log('Status Code: ${response.statusCode}');
        log('URL: ${request.url}');
        
        // Log response body if it exists
        if (response.body != null) {
          try {
            final bodyStr = response.body is String ? response.body as String : response.body.toString();
            if (bodyStr.isNotEmpty && bodyStr.length < 200) {
              try {
                final decodedBody = jsonDecode(bodyStr);
                log('Response Body: ${jsonEncode(decodedBody)}');
              } catch (e) {
                // If JSON decode fails, just log the raw string (truncated)
                log('Response Body: ${bodyStr.substring(0, min(bodyStr.length, 100))}...');
              }
            } else if (bodyStr.isNotEmpty) {
              log('Response Body: ${bodyStr.substring(0, min(bodyStr.length, 150))}...');
            } else {
              log('Response Body: Empty string');
            }
          } catch (e) {
            log('Response Body: Cannot log - ${e.toString()}');
          }
        } else {
          log('Response Body: null');
        }
        log('═══════════════════════════════════════════════════════════');
      } catch (e) {
        log('⚠️ Error in response modifier: ${e.toString()}');
      }
      return response;
    });
  }

  Future<Either<CustomError, T>> _convert<T>(
      Response response, T Function(Map<String, dynamic>) fromJson) async {
    final statusCode = response.statusCode ?? 0;
    
    // Accept all 2xx success codes (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      try {
        log('✅ API_SUCCESS: Parsing response for status $statusCode');
        // Handle both Map and String responses
        final body = response.body is Map ? response.body : (response.body ?? {});
        return Right(fromJson(body is String ? jsonDecode(body) : body));
      } catch (e, stackTrace) {
        log('❌ API_PARSE_ERROR: $e');
        log('Stack: $stackTrace');
        return Left(CustomError(statusCode, message: 'Parsing error: $e'));
      }
    } else {
      log('❌ API_ERROR: Status $statusCode');
      log('Error Message: ${response.statusText}');
      log('Response Body: ${response.body}');
      return Left(
          CustomError(statusCode, message: '${response.statusText}'));
    }
  }

  /// Wrapper to catch all network exceptions including SocketException, TimeoutException, etc.
  /// This method wraps the API call and delegates response handling to the provided handler
  Future<Either<CustomError, T>> _safeApiCall<T>(
    Future<Response> Function() apiCall,
    Future<Either<CustomError, T>> Function(Response response) handler,
  ) async {
    try {
      log('📡 Executing API call...');
      
      // Wrap the call with a timeout to catch hanging requests
      final response = await apiCall().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          log('❌ REQUEST_TIMEOUT: API call exceeded 30 seconds');
          throw TimeoutException('API request timeout after 30 seconds');
        },
      );
      
      log('✅ API call completed');
      log('   Status: ${response.statusCode}');
      log('   Body length: ${response.body?.toString().length ?? 0}');
      
      // Validate response object integrity
      if (response.statusCode == null && response.body == null) {
        log('⚠️ RESPONSE_INVALID: Both statusCode and body are null');
        log('   Response type: ${response.runtimeType}');
        log('   Response toString: ${response.toString()}');
        log('   This typically means the server closed the connection without sending data');
        return Left(CustomError(-1, message: 'Server did not send a valid response'));
      }
      
      // Handle null statusCode (can occur with incomplete responses or connection issues)
      if (response.statusCode == null) {
        log('⚠️ STATUS_CODE_NULL: Status code is null but body exists');
        log('   Response body: ${response.body}');
        return Left(CustomError(-1, message: 'Invalid response status from server'));
      }
      
      return await handler(response);
    } on SocketException catch (e) {
      log('❌ SOCKET_EXCEPTION: ${e.message}');
      log('   Stack: ${e.toString()}');
      return Left(CustomError(-1, message: 'Connection error: ${e.message}'));
    } on TimeoutException catch (e) {
      log('❌ TIMEOUT_EXCEPTION: ${e.message}');
      log('   Stack: ${e.toString()}');
      return Left(CustomError(-1, message: 'Request timeout'));
    } catch (e, stackTrace) {
      log('❌ UNKNOWN_EXCEPTION: $e');
      log('   Stack: $stackTrace');
      return Left(CustomError(-1, message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload) async {
    return _safeApiCall(
      () => post('users/login', payload.toJson()),
      (response) => _convert(response, LoginResponseModel.fromJson),
    );
  }

  @override
  Future<Either<CustomError, Response>> register(
      RegisterRequestModel register) async {
    return _safeApiCall(
      () => post('users/register', register.toJson()),
      (response) async {
        final statusCode = response.statusCode ?? 0;
        // Accept all 2xx success codes (200-299)
        if (statusCode >= 200 && statusCode < 300) {
          return Right(response);
        } else {
          return Left(CustomError(statusCode,
              message: response.statusText ?? 'Registration failed'));
        }
      },
    );
  }

  @override
  Future<Either<CustomError, String>> fetchAjkerAyat() async {
    final response = await get('ajkerqurans');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return Right(response.body['data'][0]['text']);
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message: response.statusText ?? 'Failed to fetch Ayat'));
    }
  }
  @override
  Future<Either<CustomError, List<AyatModel>>> fetchAyat() async {
    final response = await get('ajkerqurans');
    if (response.statusCode == 200 && response.body['success'] == true) {
          // Parse the JSON list and map to a model
    List<AyatModel> ayatList = (response.body['data'] as List)
        .map((json) => AyatModel.fromJson(json))
        .toList();
      return Right(ayatList);
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message: response.statusText ?? 'Failed to fetch Ayat'));
    }
  }

@override
Future<Either<CustomError, List<AjkerHadithModel>>> fetchAjkerHadith() async {
  final response = await get('ajkerhadiths');
  
  if (response.statusCode == 200 && response.body['success'] == true) {
    // Parse the JSON list and map to a model
    List<AjkerHadithModel> hadithList = (response.body['data'] as List)
        .map((json) => AjkerHadithModel.fromJson(json))
        .toList();

    return Right(hadithList);
  } else {
    return Left(CustomError(response.statusCode ?? 500,
        message: response.statusText ?? 'Failed to fetch Hadith'));
  }
}

  @override
  Future<Either<CustomError, String>> fetchAjkerSalafQuote() async {
    final response = await get('salafquotes');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return Right(response.body['data'][0]['text']);
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message: response.statusText ?? 'Failed to fetch Salaf Quote'));
    }
  }
@override
Future<Either<CustomError, List<SalafQuoteModel>>> fetchSalafQuotes() async {
  final response = await get('salafquotes');

  if (response.statusCode == 200 && response.body['success'] == true) {
    final List<dynamic> quotesData = response.body['data'];

    // Convert JSON data into a list of `SalafQuoteModel`
    List<SalafQuoteModel> salafQuotes =
        quotesData.map((quote) => SalafQuoteModel.fromJson(quote)).toList();

    return Right(salafQuotes);
  } else {
    return Left(CustomError(response.statusCode ?? 500,
        message: response.statusText ?? 'Failed to fetch Salaf Quotes'));
  }
}

  @override
  Future<Either<CustomError, Map<String, dynamic>>> fetchAjkerDua() async {
    final response = await get('ajkerduas');
    if (response.statusCode == 200 && response.body['success'] == true) {
      final data = response.body['data'][0];
      final duaData = {
        'title': data['title'],
        'bangla': data['bangla'],
        'arabic': data['arabic'],
      };
      return Right(duaData);
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message: response.statusText ?? 'Failed to fetch Dua'));
    }
  }
 Future<Either<CustomError, List<DuaModel>>> fetchDua() async {
  final response = await get('ajkerduas');

  if (response.statusCode == 200 && response.body['success'] == true) {
    final List<dynamic> data = response.body['data'];

    if (data.isNotEmpty) {
      final duaList = data.map((json) => DuaModel.fromJson(json)).toList();
      return Right(duaList);
    } else {
      return Left(CustomError(404, message: 'No Dua found for today'));
    }
  } else {
    return Left(CustomError(response.statusCode ?? 500,
        message: response.statusText ?? 'Failed to fetch Dua'));
  }
}
  @override
  Future<Either<CustomError, String>> addInputValueForUser(
      int ramadanDay, String value) async {
    final String userId = await StorageHelper.getUserId() ?? '';
    final response = await post('users/add-values/$userId', {
      'day': ramadanDay.toString(),
      'value': value,
    });
    if (response.statusCode == 200) {
      return Right("Value added successfully");
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message:
              response.statusText ?? 'Failed to add value. Please try again.'));
    }
  }

  /// Fetch tracking options for a given slug.
  // @override
  // Future<Either<CustomError, List<dynamic>>> fetchTrackingOptions(
  //     String slug) async {
  //   final response = await get('trackings/slug/$slug');
  //   if (response.statusCode == 200 &&
  //       response.body['success'] == true &&
  //       response.body['data'].isNotEmpty) {
  //     List<dynamic> options = response.body['data'][0]['options'];
  //     options.sort((a, b) => a["index"].compareTo(b["index"]));
  //     // Note: Initialize loading states externally if needed.
  //     return Right(options);
  //   } else {
  //     return Left(CustomError(response.statusCode ?? 500,
  //         message: response.statusText ?? 'Failed to load tracking options'));
  //   }
  // }
// @override
// Future<Either<CustomError, List<dynamic>>> fetchTrackingOptions(String slug) async {
//   final response = await get('trackings/slug/$slug');

//   if (response.statusCode == 200 &&
//       response.body['success'] == true &&
//       response.body['data'].isNotEmpty) {
//     try {
//       List<dynamic> options = response.body['data'][0]['options'];

//       // Sort by index
//       options.sort((a, b) => a["index"].compareTo(b["index"]));

//       // Extract users for each option
//       options = options.map((option) {
//         return {
//           ...option,
//           'users': option['users'] ?? [], // Ensure users list exists
//         };
//       }).toList();

//       return Right(options);
//     } catch (e) {
//       return Left(CustomError(500, message: 'Data parsing error: ${e.toString()}'));
//     }
//   } else {
//     return Left(CustomError(
//       response.statusCode ?? 500,
//       message: response.statusText ?? 'Failed to load tracking options',
//     ));
//   }
// }
@override
Future<Either<CustomError, List<TrackingOption>>> fetchTrackingOptions(String slug) async {
  final response = await get('trackings/slug/$slug');

  if (response.statusCode == 200 &&
      response.body['success'] == true &&
      response.body['data'].isNotEmpty) {
    try {
      List<dynamic> rawOptions = response.body['data'][0]['options'];
      // Convert index to int for sorting
      rawOptions.sort((a, b) {
        final aIndex = int.parse(a["index"].toString());
        final bIndex = int.parse(b["index"].toString());
        return aIndex.compareTo(bIndex);
      });
      final options = rawOptions.map((e) => TrackingOption.fromJson(e)).toList();
      return Right(options);
    } catch (e) {
      return Left(CustomError(500, message: 'Data parsing error: ${e.toString()}'));
    }
  } else {
    return Left(CustomError(
      response.statusCode ?? 500,
      message: response.statusText ?? 'Failed to load tracking options',
    ));
  }
}

  /// Add points for a user.
  @override
  Future<Either<CustomError, String>> addPoints(
      String userId, int ramadanDay, int points) async {
    final response = await patch(
      'users/points/$userId/',
      {
        "points": points,
        "day": "day$ramadanDay",
      },
    );
    if (response.statusCode == 200) {
      final data = response.body;
      if (data["success"]) {
        return Right("Points added successfully");
      } else {
        return Left(CustomError(response.statusCode ?? 500,
            message: "Failed to add points"));
      }
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message: "Server error: ${response.statusCode}"));
    }
  }

  /// Update a user's tracking option.
  @override
  Future<Either<CustomError, String>> updateUserTrackingOption(
      String slug, String optionId, String userId, int ramadanDay, Map<String, dynamic> additionalData) async {
    final day = 'day$ramadanDay';
    final response = await patch(
      'trackings/add-user-to-tracking/$slug/$optionId',
      {
        'user': userId,
        'day': day,
        ...additionalData, // Include additional data in the request
      },
    );
    if (response.statusCode == 200) {
      return Right("Update successful");
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message:
              'Failed to update user tracking option. Status code: ${response.statusCode}'));
    }
  }

  @override
  Future<Either<CustomError, List<UserModel>>> fetchUsers() async {
    final response = await get('users');
    if (response.statusCode == 200 && response.body['success'] == true) {
      final List<dynamic> jsonList = response.body['data'];
      final List<UserModel> users =
          jsonList.map((item) => UserModel.fromJson(item)).toList();
      return Right(users);
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message: response.statusText ?? 'Failed to fetch users'));
    }
  }

  @override
  Future<Either<CustomError, int>> fetchTodaysPoint(
      String userId, int ramadanDay) async {
    final response = await get('users/points/$userId/day$ramadanDay');
    if (response.statusCode == 200 && response.body['success'] == true) {
      return Right(response.body['data']['total'] ?? 0);
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message: response.statusText ?? 'Failed to fetch today\'s points'));
    }
  }

  // @override
  // Future<Either<CustomError, Map<String, dynamic>>> fetchUserRanking() async {
  //   final response = await get('users');
  //   if (response.statusCode == 200 && response.body['success'] == true) {
  //     return Right(response.body);
  //   } else {
  //     return Left(CustomError(response.statusCode ?? 500,
  //         message: response.statusText ?? 'Failed to fetch user ranking'));
  //   }
  // }
  /// Fetch all users and determine the current user's rank and points
  @override
  Future<Either<CustomError, Map<String, dynamic>>>
      fetchCurrentUserRankAndPoints(String userId) async {
    final response = await get('users');
    if (response.statusCode == 200 && response.body['success'] == true) {
      final List<dynamic> userList = response.body['data'];

      // Sort users by total points in descending order
      userList.sort(
          (a, b) => (b["totalPoints"] ?? 0).compareTo(a["totalPoints"] ?? 0));

      // Find current user's rank and points
      int rank = 0;
      int points = 0;
      for (int i = 0; i < userList.length; i++) {
        if (userList[i]["_id"] == userId) {
          rank = i + 1;
          points = userList[i]["totalPoints"] ?? 0;
          break;
        }
      }

      return Right({"rank": rank, "totalPoints": points});
    } else {
      return Left(CustomError(response.statusCode ?? 500,
          message:
              response.statusText ?? 'Failed to fetch user rank and points'));
    }
  }

  @override
  Future<Either<CustomError, Map<String, dynamic>>>
      fetchCurrentUserPoints() async {
    try {
      final response = await get('users');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Right(data);
      }
      return Left(CustomError(response.statusCode ?? 500,
          message: response.body ?? "Failed to fetch user points"));
    } catch (e) {
      return Left(CustomError(500, message: e.toString()));
    }
  }

  /// **Fetch Koroniyo List**
  @override
  Future<Either<CustomError, List<KoroniyoModel>>> fetchKoroniyo() async {
    final response = await get('koroniyos');

    if (response.statusCode == 200 && response.body['success'] == true) {
          // **Fix: Convert JSON list to List<KoroniyoModel>**
      final List<KoroniyoModel> koroniyoList = (response.body['data'] as List)
          .map((item) => KoroniyoModel.fromJson(item))
          .toList();
      return Right(koroniyoList); // ✅ Return data list
    } else {
      return Left(CustomError(
        response.statusCode ?? 500,
        message: response.statusText ?? 'Failed to load Koroniyo',
      ));
    }
  }

  /// **Fetch Borjoniyo List**
  @override
  Future<Either<CustomError, List<BorjoniyoModel>>> fetchBorjoniyo() async {
    final response = await get('borjoniyos');

    if (response.statusCode == 200 && response.body['success'] == true) {
      final List<dynamic> data = response.body['data'];
      final List<BorjoniyoModel> borjoniyoList =
          data.map((item) => BorjoniyoModel.fromJson(item)).toList();
      return Right(borjoniyoList);
    } else {
      return Left(CustomError(
        response.statusCode ?? 500,
        message: response.statusText ?? 'Failed to load Borjoniyo',
      ));
    }
  }
    @override
  Future<Map<String, dynamic>> fetchLatestVersion() async {
    final response = await http.get(Uri.parse('https://ramadan-tracker-app-info.vercel.app/api/v1/app-info')); // Replace with your actual URL
    

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['success'] == true && json['data'] != null) {
        final data = json['data']; // Direct map (not a list anymore)
        debugPrint("download_link ${data['download_link']}");
        debugPrint("version ${data['version']}");
        return {
          "version": data['version'],
          "download_link": data['download_link'],
        };
      } else {
        throw Exception('Invalid API Response');
      }
    } else {
      throw Exception('Failed to fetch update info');
    }
  }
}
