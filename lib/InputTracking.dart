import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors.dart'; // Ensure you have this file in your project

class InputTracking extends StatefulWidget {
  final int ramadan_day;


  InputTracking({Key? key, required this.ramadan_day}) : super(key: key);

  @override
  State<InputTracking> createState() => _InputTrackingState();
}

class _InputTrackingState extends State<InputTracking> {
  final LocalStorage storage = LocalStorage('ramadan_tracker');
  List<Map<String, dynamic>> trackingOptions = [];
  bool isLoading = true;
String generateUniqueId() {
  var now = DateTime.now();
  var random = Random();
  
  // Combine current time in milliseconds since epoch and a random number
  return "${now.millisecondsSinceEpoch}${random.nextInt(10000)}";
}// Generates a version 4 UUID
  @override
  void initState() {
    super.initState();
    initSetup();
    
  }
  void initSetup() async {
  // Fetch user details
  final userDetails = await fetchUserDetails();
  // Extract values for the specific day if they exist
  final dayValues = userDetails['values']?.where((v) => v['day'] == 'day${widget.ramadan_day}').toList() ?? [];
  // Fetch tracking options and update them with initial values from user details
  await fetchTrackingOptions(dayValues);
}
Future<void> fetchTrackingOptions(List<dynamic> dayValues) async {
  final response = await http.get(
    Uri.parse('https://ramadan-tracker-server.vercel.app/api/v1/trackings/slug/afternoon_tracking'),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data["success"] && data["data"].isNotEmpty) {
      setState(() {
        trackingOptions = data["data"][0]["options"].map<Map<String, dynamic>>((option) {
          // Find the initial value for this option, if it exists
          var initialValue = dayValues.firstWhere((val) => val['id'] == option['_id'], orElse: () => null)?['value'] ?? '';
          return {
            "title": option["title"],
            "controller": TextEditingController(text: initialValue),
            "point": option["point"],
            "id": option['_id']
          };
        }).toList();
        isLoading = false;
      });
    }
  }
}

Future<Map<String, dynamic>> fetchUserDetails() async {
  await storage.ready;
  String userId = storage.getItem('_id');

  final response = await http.get(
    Uri.parse('https://ramadan-tracker-server.vercel.app/api/v1/users/$userId'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data["success"]) {
      return data["data"];
    }
  }
  return {};
}
Future<void> updateSpecialObtains({required String userId, required String day, required String value, required String id}) async {
  final response = await http.patch(
    Uri.parse('https://ramadan-tracker-server.vercel.app/api/v1/users/add-special-obtains/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'day': day,
      'value': value,
      'id': id,
    }),
  );

  if (response.statusCode == 200) {
    Fluttertoast.showToast(msg: "Saved successfully");
  } else {
    Fluttertoast.showToast(msg: "Failed to save");
    print('Failed to update special obtains. Status code: ${response.statusCode}');
  }
}

@override
Widget build(BuildContext context) {
  if (isLoading) {
    return CircularProgressIndicator();
  }
  return SingleChildScrollView(
    child: Column(
      children: [
        ...trackingOptions.map((option) {
          return Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: option['controller'],
                    decoration: InputDecoration(
                      labelText: option['title'],
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await updateSpecialObtains(
                        userId: storage.getItem('_id'), // Assuming you store the user's ID in local storage
                        day: 'day${widget.ramadan_day}',
                        value: option['controller'].text,
                        id: option['id'], // Make sure your option map includes the 'id' you need to send
                      );
                    },
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.PrimaryColor),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  );
}}