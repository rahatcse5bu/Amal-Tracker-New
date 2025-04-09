//import main.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../colors.dart';
import '../Data/data.dart';
//import firebase core and firestore
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../Data/localStorageFunc.dart';

// class Night_Todo extends StatefulWidget {
//   Night_Todo({super.key, required this.ramadan_day});
//   int ramadan_day;
//   @override
//   State<Night_Todo> createState() => _Night_TodoState();
// }

// class _Night_TodoState extends State<Night_Todo> {
//   bool? val = false;
//   LocalStorage storage = new LocalStorage('ramadan_planner_1');

//   // final CollectionReference _users =
//   //     FirebaseFirestore.instance.collection('users');
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Todo list with SwitchListTile widget and a button to add new todo
//         Column(children: [
//           Card(
//               elevation: 5,
//               child: Padding(
//                   padding:
//                       EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
//                   child: Column(children: [
//                     Container(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(6),
//                               topRight: Radius.circular(6)),
//                           color: AppColors.PrimaryColor),
//                       child: Center(
//                         child: Text(
//                           "রাত ট্রাকিং:",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     // CheckboxListTile

//                     for (var i = 0; i < Night_Items.length; i++) ...[
//                       CheckboxListTile(
//                         secondary: Night_Items[i]['isChecked'] == false
//                             ? Icon(
//                                 Icons.close,
//                                 color: Colors.red,
//                               )
//                             : Icon(
//                                 Icons.check,
//                                 color: AppColors.PrimaryColor,
//                               ),
//                         activeColor: Night_Items[i]['isChecked'] == false
//                             ? Colors.red
//                             : AppColors.PrimaryColor,
//                         controlAffinity: ListTileControlAffinity.leading,
//                         title: Text(Night_Items[i]['title']),
//                         isThreeLine: true,
//                         subtitle: ExpandableText(
//                           Night_Items[i]['subTitle'],
//                           expandText: 'show more',
//                           collapseText: 'show less',
//                           maxLines: 2,
//                           linkColor: Colors.blue,
//                           style: TextStyle(
//                               fontStyle: FontStyle.italic, fontSize: 12),
//                         ),
//                         // Text(
//                         //   Night_Items[i]['subTitle'],
//                         //   style: TextStyle(fontSize: 10),
//                         // ),
//                         value: Night_Items[i]['isChecked'],
//                         onChanged: (newValue) async {
//                           Night_Items[i]['isChecked'] = newValue;

//                           setState(() {
//                             Night_Items[i]['isChecked'] = newValue;
//                             setValueToLocalStorage(
//                                 'Night_Items' + widget.ramadan_day.toString(),
//                                 json.encode(Night_Items));
//                             if (Night_Items.where((e) => e['isChecked'] == true)
//                                     .length ==
//                                 Night_Items.length) {
//                               showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Icon(Icons.check_circle,
//                                               color: AppColors.PrimaryColor),
//                                           SizedBox(width: 2),
//                                           Text('জাযাকাল্লহু খইরন!'),
//                                         ],
//                                       ),
//                                       content: Text(
//                                           "জাযাকাল্লহু খইরন। আপনি সফলভাবে আজকের রাতের কাজগুলো সম্পন্ন করেছেন! "),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Center(child: Text('ঠিক আছে')),
//                                         ),
//                                       ],
//                                     );
//                                   });
//                               print("All Done");
//                             }

//                             storage.setItem(
//                                 'Night_Items_Count' +
//                                     widget.ramadan_day.toString(),
//                                 Night_Items.where((e) => e['isChecked'] == true)
//                                     .length);
//                             setState(() {
//                               todays_point = Night_Items.where(
//                                   (e) => e['isChecked'] == true).length;
//                               // _users.add({"name": "Rahat", "price": 23});
//                             });
//                             print("todays point" + todays_point.toString());
//                             print("Day: " + widget.ramadan_day.toString());
//                             print(
//                                 Night_Items.where((e) => e['isChecked'] == true)
//                                     .length);
//                           });
//                         },
//                       ),
//                     ]
//                   ]))),
//         ])
//       ],
//     );
//   }
// }
class NightTrackingPage extends StatefulWidget {
  final int ramadan_day;

  NightTrackingPage({Key? key, required this.ramadan_day}) : super(key: key);

  @override
  _NightTrackingPageState createState() => _NightTrackingPageState();
}

class _NightTrackingPageState extends State<NightTrackingPage> {
  final LocalStorage storage = LocalStorage('ramadan_tracker');
  Future<List<dynamic>>? trackingOptionsFuture;
Future<List<dynamic>> fetchTrackingOptions() async {
  final response = await http.get(
    Uri.parse('https://ramadan-tracker-server.vercel.app/api/v1/trackings/slug/night_tracking'),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data["success"] && data["data"].isNotEmpty) {
      // Assuming 'data' always contains at least one element and we're interested in the 'options' of the first one.
      return data["data"][0]["options"];
    } else {
      throw Exception('Failed to load tracking options');
    }
  } else {
    throw Exception('Failed to load tracking options');
  }
}


  Future<void> updateUserTrackingOption(String optionId, bool isChecked) async {
    final userId = storage.getItem('_id');
    final day = 'day${widget.ramadan_day}';
    print("Updating option $optionId for user $userId to $isChecked on $day");

    final response = await http.patch(
      Uri.parse('https://ramadan-tracker-server.vercel.app/api/v1/trackings/add-user-to-tracking/night_tracking/$optionId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user': userId,
        'day': day,
      }),
    );

    if (response.statusCode == 200) {
      print("Update successful");
      refreshOptions();
    } else {
      print('Failed to update user tracking option. Status code: ${response.statusCode}');
         refreshOptions();
    }
  }

  void refreshOptions() {
    setState(() {
      trackingOptionsFuture = fetchTrackingOptions(); // Refresh options
    });
  }

    @override
  void initState() {
    super.initState();
    trackingOptionsFuture = fetchTrackingOptions();
  }
bool isUserChecked(List<dynamic> users, String day) {
  final userId = storage.getItem('_id');
  // Iterate over the users list to find a match for both user ID and day.
  return users.any((user) => user['user'] == userId && user['day'] == day);
}

  @override
  Widget build(BuildContext context) {
    return 
    
FutureBuilder<List<dynamic>>(
  future: trackingOptionsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      final options = snapshot.data!;
      return 
      
      SingleChildScrollView( // Use SingleChildScrollView for overall scrolling
        child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.only(bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)),
                    color: AppColors.PrimaryColor, // Define this color
                  ),
                  child: Center(
                    child: Text(
                      "রাত ট্রাকিং:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Generate CheckboxListTile for each option
                ...options.map<Widget>((option) => CheckboxListTile(
                  title: Text(option['title']),
                  // title: Text(option['title']+isUserChecked(option['users'], 'day${widget.ramadan_day}').toString()),
                  subtitle: ExpandableText(
                    option['description'],
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 8,
                    linkColor: Colors.blue,
                  ),
                  value: isUserChecked(option['users'], 'day${widget.ramadan_day}'),
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      updateUserTrackingOption(option['_id'], newValue);
                    }
                  },
                )).toList(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Text("No options available");
    }
  },
);

  }
}