import 'package:shared_preferences/shared_preferences.dart';

import '../../../Data/data.dart';

class StorageHelper {
  static const String _tokenKey = "auth_token";
  static const String _userKey = "user_data";
  static const String _userId = "userId";
  static const String _userNameKey = "userName";
  static const String _fullNameKey = "fullName";
  static const String _specialAchievementKey = "specialAchievement_";
  static const String _languageCode = "language_code";
  static const String _countryCode = "country_code";
// Key prefix for Good Afternoon items
static const String _goodAfternoonKey = "Good_Afternoon_Items_inputs_";

  // Set token
  static Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove token (optional, for logout)
  static Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
  // Set user name
  static Future<void> setUserName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  // Get username
  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Remove username (optional, for logout)
  static Future<void> removeUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
  }
  // Set full name
  static Future<void> setFullName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fullNameKey, name);
  }

  // Get username
  static Future<String?> getFullName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  // Remove username (optional, for logout)
  static Future<void> removeFullName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fullNameKey);
  }

  // Check if token exists
  static Future<bool> hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  // Set token
  static Future<void> setUserData(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData.toString());
    await prefs.setString('userId', userData.toString());
  }

  // Get token
  static Future<String?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  // Remove user data (optional, for logout)
  static Future<void> removeUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }


    // Set user Id
  static Future<void> setUserId(String userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userId, userData.toString());

  }

  // Get user id
  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId);
  }

  // Remove user id (optional, for logout)
  static Future<void> removeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userId);
  }
    // Set specialAchievementKey
  static Future<void> addSpecialAchievement(String data,String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("$_specialAchievementKey$date", data.toString());

  }

  // Get specialAchievementKey
  static Future<String?> getSpecialAchievement(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("$_specialAchievementKey$date");
  }

  // Remove specialAchievementKey
  static Future<void> removeSpecialAchievement(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("$_specialAchievementKey$date");
  }


   // Save language settings
  static Future<void> setLanguage(String languageCode, String countryCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCode, languageCode);
    await prefs.setString(_countryCode, countryCode);
  }

  // Get language code
  static Future<String?> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageCode);
  }

  // Get country code
  static Future<String?> getCountryCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryCode);
  }

  // Remove language settings (optional, for reset)
  static Future<void> removeLanguageSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageCode);
    await prefs.remove(_countryCode);
  }


// Save Good Afternoon item for a specific Ramadan day & field index
static Future<void> setGoodAfternoonItem(int ramadanDay, int index, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("$_goodAfternoonKey${ramadanDay}_$index", value);
}

// Get Good Afternoon item for a specific Ramadan day & field index
static Future<String?> getGoodAfternoonItem(int ramadanDay, int index) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("$_goodAfternoonKey${ramadanDay}_$index");
}

// Optional: Clear one item if needed
static Future<void> clearGoodAfternoonItem(int ramadanDay, int index) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("$_goodAfternoonKey${ramadanDay}_$index");
}

// Optional: Clear all for a given Ramadan day (if you want a "Clear All" button later)
static Future<void> clearAllGoodAfternoonItems(int ramadanDay) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  for (int i = 0; i < Good_Afternoon_Items_inputs.length; i++) {
    await prefs.remove("$_goodAfternoonKey${ramadanDay}_$i");
  }}

  static Future<bool> isLoggedIn() async {
  final token = await getToken();
  final username = await getUserName();
  final userId = await getUserId();

  return token != null &&
      token.isNotEmpty &&
      username != null &&
      username.isNotEmpty &&
      userId != null &&
      userId.isNotEmpty;
}

}
