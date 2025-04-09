import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:localstorage/localstorage.dart';

class PlannerController extends GetxController {
  final LocalStorage storage = LocalStorage('ramadan_tracker');
  var todaysPoint = 0.obs; // Observable for today's points
  var isLoadingPoint = true.obs; // Observable for loading state
  var userRank = 0.obs; // Observable for user rank state
  var users = [].obs;
  var isLoadingUsers = true.obs;
var totalPoints = 0.obs; 
    @override
  void onInit() {
    super.onInit();
    fetchCurrentUserPoints();
  }
  // Method to fetch today's points
  Future<void> fetchTodaysPoint(int ramadanDay) async {
    await storage.ready;
    String user_id = storage.getItem('_id');
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/users/points/$user_id/day$ramadanDay'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"]) {
        todaysPoint.value = data["data"]["total"];
        isLoadingPoint.value = false;
      }
       isLoadingPoint.value = false;
    } else {
      isLoadingPoint.value = false;
    }
  }

void fetchCurrentUserPoints() async {
  isLoadingUsers.value = true;
  final userId = storage.getItem('_id'); // Assuming the user's ID is stored with key '_id'
  final response = await http.get(
    Uri.parse('https://ramadan-tracker-server.vercel.app/api/v1/users')
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> fetchedUsers = data["data"];

    // Sort users by their totalPoints in descending order
    fetchedUsers.sort((a, b) {
      int aPoints = a["totalPoints"] ?? 0; // Assuming totalPoints is at this level, adjust according to your API
      int bPoints = b["totalPoints"] ?? 0;
      return bPoints.compareTo(aPoints);
    });

    // Find the current user's data including their rank
    int currentUserRank = 0; // Initialize with a default or error value
    for (int i = 0; i < fetchedUsers.length; i++) {
      if (fetchedUsers[i]["user"]["_id"] == userId) {
        currentUserRank = i + 1; // Rank is the index + 1
        totalPoints.value = fetchedUsers[i]["totalPoints"] ?? 0; // Update totalPoints for the current user
        break; // Exit the loop once the current user is found
      }
    }

    // If needed, update an observable for the user's rank
    userRank.value = currentUserRank;

    isLoadingUsers.value = false;
  } else {
    isLoadingUsers.value = false;
    totalPoints.value = 0; // Error state
    userRank.value = 0; // Default or error value for rank
  }
}


}
