import 'dart:convert';
import 'package:expandable_text/expandable_text.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ramadan_tracker/planner.dart';

import 'PlannerController.dart';
import 'colors.dart';

class TrackingOld extends StatefulWidget {
  final int ramadan_day;
  final String slug;
  final String type;
  TrackingOld({
    Key? key,
    required this.ramadan_day,
    required this.slug,
    required this.type,
  }) : super(key: key);

  @override
  _TrackingOldState createState() => _TrackingOldState();
}

class _TrackingOldState extends State<TrackingOld> {
  final PlannerController plannerController = Get.put(PlannerController());
  final LocalStorage storage = LocalStorage('ramadan_tracker');
  Future<List<dynamic>>? trackingOptionsFuture;
  Map<String, bool> loadingStates = {};

  int todays_point = 0;
  bool isLoadingPoint = true;
  Future<List<dynamic>> fetchTrackingOptions() async {
    final response = await http.get(
      Uri.parse(
          'https://ramadan-tracker-server.vercel.app/api/v1/trackings/slug/' +
              widget.slug.toString()),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["success"] && data["data"].isNotEmpty) {
        // Assuming 'data' always contains at least one element and we're interested in the 'options' of the first one.
        // Sort the options by their index before returning
        List<dynamic> options = data["data"][0]["options"];
        options.sort((a, b) => a["index"].compareTo(b["index"]));
        // After successfully fetching the options, initialize loading states:
        for (var option in options) {
          loadingStates[option['_id']] =
              false; // Assume '_id' uniquely identifies each option
        }
        return options;
        // return data["data"][0]["options"];
      } else {
        throw Exception('Failed to load tracking options');
      }
    } else {
      throw Exception('Failed to load tracking options');
    }
  }

  // Function to add points
  Future<void> addPoints(int points) async {
    final userId = await storage.getItem('_id');
    final Uri url = Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/users/points/$userId/');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"points": points, "day": "day" + widget.ramadan_day.toString()}),
      );
      print("point--->" + jsonDecode(response.body).toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"]) {
          // Handle success
          print("Points added successfully");
        } else {
          // Handle the case where the operation was not successful
          print("Failed to add points");
        }
      } else {
        // Handle server errors
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print("Error adding points: $e");
    }
  }

  Future<void> updateUserTrackingOption(String optionId, bool isChecked) async {
    final userId = await storage.getItem('_id');
    final day = 'day${widget.ramadan_day}';
    print("Updating option $optionId for user $userId to $isChecked on $day");
    setState(() {
      loadingStates[optionId] = true; // Start loading
    });
    final response = await http.patch(
      Uri.parse(
          'https://ramadan-tracker-server.vercel.app/api/v1/trackings/add-user-to-tracking/' +
              widget.slug.toString() +
              '/$optionId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user': userId,
        'day': day,
      }),
    );
    // After the HTTP request is complete (success or failure):
    setState(() {
      loadingStates[optionId] = false; // End loading
    });
    if (response.statusCode == 200) {
      print("Update successful");
      plannerController.fetchTodaysPoint(widget.ramadan_day);
      // refreshOptions();
    } else {
      print(
          'Failed to update user tracking option. Status code: ${response.statusCode}');
      // refreshOptions();
    }
  }

  void refreshOptions() {
    setState(() {
      trackingOptionsFuture = fetchTrackingOptions(); // Refresh options
    });
  }

  Future<int> fetchTodaysPoint() async {
    await storage.ready;
    String user_id = storage.getItem('_id');
    final response = await http.get(Uri.parse(
        'https://ramadan-tracker-server.vercel.app/api/v1/users/points/' +
            user_id.toString() +
            '/day' +
            widget.ramadan_day.toString()));
    // print('https://ramadan-tracker-server.vercel.app/api/v1/users/points/' +
    //     user_id.toString() +
    //     '/day' +
    //     widget.ramadan_day.toString());
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print("ponits=?>"+data.toString());
      if (data["success"]) {
        print("ponits=??>" + data["data"]['total'].toString());
        setState(() {
          todays_point = data["data"]["total"];
          isLoadingPoint = false;
        });
        return todays_point;
      }
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    fetchTodaysPoint();
    trackingOptionsFuture = fetchTrackingOptions();
  }

  bool isUserChecked(List<dynamic> users, String day) {
    final userId = storage.getItem('_id');
    // Iterate over the users list to find a match for both user ID and day.
    return users.any((user) => user['user'] == userId && user['day'] == day);
  }

  String getTrackingName() {
    return widget.slug == 'night_tracking'
        ? "রাত ট্রাকিং:"
        : widget.slug == "fajr_tracking"
            ? "ফজর ট্রাকিং"
            : widget.slug == "zuhr_tracking"
                ? "যোহর ট্রাকিং"
                : widget.slug == "asr_tracking"
                    ? "আসর ট্রাকিং"
                    : widget.slug == "afternoon_tracking"
                        ? "বিকেল ট্রাকিং"
                        : widget.slug == "qadr_tracking"
                            ? "ক্বদর ট্রাকিং"
                            : widget.slug == "general_tracking"
                                ? "অত্যন্ত প্রয়োজনীয়"
                                : widget.slug == "evening_tracking"
                                    ? "সন্ধ্যা ট্রাকিং"
                                    : "";
  }

  Widget _todayPoints(BuildContext context) {
    return Card(
      child: Container(
        // color: AppColors.PrimaryColor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          color: AppColors.PrimaryColor,
        ),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Column(
          children: [
            Text(
              // "আপনার আজকের পয়েন্ট: ${storage.getItem('Night_Items_Count' + widget.ramadan_day.toString())}",
              "আজকের পয়েন্ট: $todays_point",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchTrackingOptions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: AppColors.PrimaryColor,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final options = snapshot.data!;

          // Decide widget type based on widget.type
          return widget.type == "checkbox"
              ? widget.ramadan_day > 20 && widget.slug == 'qadr_tracking'
                  ? ExpansionTile(
                      //icon background color
                      collapsedBackgroundColor: Colors.transparent,
                      collapsedIconColor: Colors.white,
                      // backgroundColor: AppColors.PrimaryColor,
                      iconColor: Colors.white,
                      subtitle: Center(
                          child: widget.ramadan_day % 2 == 0
                              ? Text(
                                  "আজ ${widget.ramadan_day} রমাদ্বন। আজ শেষ দশকের একটি (জোড়) রাত। আজ রাতেও 'আমাল করুন।জোড় রাতেও লাইলাতুল ক্বদর হতে পারে।(ক্বদের বিশেষ 'আমাল পেতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)",
                                  style:
                                      TextStyle(color: AppColors.PrimaryColor),
                                )
                              : Text(
                                  "আজ ${widget.ramadan_day} রমাদ্বন। আজ শেষ দশকের বিজোড় রাত।  বিজোড় রাতে বেশি বেশি 'আমাল করুন।সারারাত ধরে 'আমাল করুন।  বিজোড় রাতগুলিতে লাইলাতুল ক্বদর হওয়ার সম্ভাবনা প্রবল।(ক্বদের বিশেষ 'আমাল পেতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)",
                                  style:
                                      TextStyle(color: AppColors.PrimaryColor),
                                )),
                      trailing: Icon(Icons.arrow_drop_down_circle,
                          color: AppColors.PrimaryColor, size: 30),
                      title: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        margin: EdgeInsets.only(bottom: 5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6)),
                            color: AppColors.PrimaryColor),
                        child: Center(
                          child: Text(
                            "ক্বদর ট্রাকিং:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      children: [
                        Card(
                            elevation: 5,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Column(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    margin: EdgeInsets.only(bottom: 5),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      color: AppColors
                                          .PrimaryColor, // Define this color
                                    ),
                                    child: Center(
                                      child: Text(
                                        getTrackingName(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: options.map<Widget>((option) {
                                        return CheckboxListTile(
                                          secondary: loadingStates[option['_id']] == true
                                      ? CircularProgressIndicator() // Show loading indicator
                                      :isUserChecked(
                                                      option['users'],
                                                      'day${widget.ramadan_day}') ==
                                                  false
                                              ? Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.check,
                                                  color: AppColors.PrimaryColor,
                                                ),
                                                activeColor:
                                                    AppColors.PrimaryColor,
                                                title: Text(option['title'] +
                                                    " [" +
                                                    option['point'].toString() +
                                                    " Points]"),
                                                subtitle: ExpandableText(
                                                  option['description'],
                                                  expandText: 'show more',
                                                  collapseText: 'show less',
                                                  maxLines: 2,
                                                  linkColor: Colors.blue,
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 12),
                                                ),
                                                value: isUserChecked(
                                                    option['users'],
                                                    'day${widget.ramadan_day}'),
                                                onChanged: (bool? newValue) {
                                                  if (newValue != null) {
                                                    updateUserTrackingOption(
                                                        option['_id'],
                                                        newValue);
                                                    if (!isUserChecked(
                                                        option['users'],
                                                        'day${widget.ramadan_day}')) {
                                                      //positive for chcek
                                                      addPoints(
                                                          option['point']);
                                                    } else {
                                                      //negetive for unchcek
                                                      addPoints(
                                                          option['point'] * -1);
                                                    }
                                                  }
                                                },
                                              );
                                      }).toList())
                                ]))),
                      ],
                    )
                  : Card(
                      elevation: 5,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          child: Column(children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              margin: EdgeInsets.only(bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color:
                                    AppColors.PrimaryColor, // Define this color
                              ),
                              child: Center(
                                child: Text(
                                  getTrackingName(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: options.map<Widget>((option) {
                                  return  CheckboxListTile(
                                          secondary: loadingStates[option['_id']] == true
                                      ? CircularProgressIndicator() // Show loading indicator
                                      :isUserChecked(
                                                      option['users'],
                                                      'day${widget.ramadan_day}') ==
                                                  false
                                              ? Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.check,
                                                  color: AppColors.PrimaryColor,
                                                ),
                                          activeColor: isUserChecked(
                                                      option['users'],
                                                      'day${widget.ramadan_day}') ==
                                                  false
                                              ? Colors.red
                                              : AppColors.PrimaryColor,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: Text(option['title'] +
                                              " [" +
                                              option['point'].toString() +
                                              " Points]"),
                                          subtitle: ExpandableText(
                                            option['description'],
                                            expandText: 'show more',
                                            collapseText: 'show less',
                                            maxLines: 2,
                                            linkColor: Colors.blue,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 12),
                                          ),
                                          value: isUserChecked(option['users'],
                                              'day${widget.ramadan_day}'),
                                          onChanged: (bool? newValue) {
                                            if (newValue != null) {
                                              updateUserTrackingOption(
                                                  option['_id'], newValue);
                                              if (!isUserChecked(
                                                  option['users'],
                                                  'day${widget.ramadan_day}')) {
                                                //positive for chcek
                                                addPoints(option['point']);
                                              } else {
                                                //negetive for unchcek
                                                addPoints(option['point'] * -1);
                                              }
                                            }
                                          },
                                        );
                                }).toList())
                          ])))
              : widget.type == "switch"
                  ? widget.ramadan_day > 20 && widget.slug == 'qadr_tracking'
                      ? ExpansionTile(
                          //icon background color
                          collapsedBackgroundColor: Colors.transparent,
                          collapsedIconColor: Colors.white,
                          // backgroundColor: AppColors.PrimaryColor,
                          iconColor: Colors.white,
                          subtitle: Center(
                              child: widget.ramadan_day % 2 == 0
                                  ? Text(
                                      "আজ ${widget.ramadan_day} রমাদ্বন। আজ শেষ দশকের একটি (জোড়) রাত। আজ রাতেও 'আমাল করুন।জোড় রাতেও লাইলাতুল ক্বদর হতে পারে।(ক্বদের বিশেষ 'আমাল পেতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)",
                                      style: TextStyle(
                                          color: AppColors.PrimaryColor),
                                    )
                                  : Text(
                                      "আজ ${widget.ramadan_day} রমাদ্বন। আজ শেষ দশকের বিজোড় রাত।  বিজোড় রাতে বেশি বেশি 'আমাল করুন।সারারাত ধরে 'আমাল করুন।  বিজোড় রাতগুলিতে লাইলাতুল ক্বদর হওয়ার সম্ভাবনা প্রবল।(ক্বদের বিশেষ 'আমাল পেতে ডানপাশের অ্যারো বাটনে ক্লিক করুন)",
                                      style: TextStyle(
                                          color: AppColors.PrimaryColor),
                                    )),
                          trailing: Icon(Icons.arrow_drop_down_circle,
                              color: AppColors.PrimaryColor, size: 30),
                          title: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            margin: EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                color: AppColors.PrimaryColor),
                            child: Center(
                              child: Text(
                                "ক্বদর ট্রাকিং:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          children: [
                            Card(
                                elevation: 5,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        left: 10,
                                        right: 10,
                                        bottom: 10),
                                    child: Column(children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        margin: EdgeInsets.only(bottom: 5),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6)),
                                          color: AppColors
                                              .PrimaryColor, // Define this color
                                        ),
                                        child: Center(
                                          child: Text(
                                            getTrackingName(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: options.map<Widget>((option) {
                                          return  SwitchListTile(
                                                  secondary: loadingStates[option['_id']] == true
                                        ? CircularProgressIndicator() // Show loading indicator
                                        :  isUserChecked(
                                                              option['users'],
                                                              'day${widget.ramadan_day}') ==
                                                          false
                                                      ? Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        )
                                                      : Icon(
                                                          Icons.check,
                                                          color: AppColors
                                                              .PrimaryColor,
                                                        ),
                                                  activeColor: isUserChecked(
                                                              option['users'],
                                                              'day${widget.ramadan_day}') ==
                                                          false
                                                      ? Colors.red
                                                      : AppColors.PrimaryColor,
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                  title: Text(option['title'] +
                                                      " [" +
                                                      option['point']
                                                          .toString() +
                                                      " Points]"),
                                                  subtitle: ExpandableText(
                                                    option['description'],
                                                    expandText: 'show more',
                                                    collapseText: 'show less',
                                                    maxLines: 2,
                                                    linkColor: Colors.blue,
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 12),
                                                  ),
                                                  value: isUserChecked(
                                                      option['users'],
                                                      'day${widget.ramadan_day}'),
                                                  onChanged: (bool? newValue) {
                                                    if (newValue != null) {
                                                      updateUserTrackingOption(
                                                          option['_id'],
                                                          newValue);
                                                      if (!isUserChecked(
                                                          option['users'],
                                                          'day${widget.ramadan_day}')) {
                                                        //positive for chcek
                                                        addPoints(
                                                            option['point']);
                                                      } else {
                                                        //negetive for unchcek
                                                        addPoints(
                                                            option['point'] *
                                                                -1);
                                                      }
                                                    }
                                                  },
                                                );
                                        }).toList(),
                                      )
                                    ]))),
                          ],
                        )
                      : Card(
                          elevation: 5,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 10, right: 10, bottom: 10),
                              child: Column(children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  margin: EdgeInsets.only(bottom: 5),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: AppColors
                                        .PrimaryColor, // Define this color
                                  ),
                                  child: Center(
                                    child: Text(
                                      getTrackingName(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: options.map<Widget>((option) {
                                    return SwitchListTile(
                                            secondary:loadingStates[option['_id']] == true
                                        ? CircularProgressIndicator() // Show loading indicator
                                        :  isUserChecked(
                                                        option['users'],
                                                        'day${widget.ramadan_day}') ==
                                                    false
                                                ? Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  )
                                                : Icon(
                                                    Icons.check,
                                                    color:
                                                        AppColors.PrimaryColor,
                                                  ),
                                            activeColor: isUserChecked(
                                                        option['users'],
                                                        'day${widget.ramadan_day}') ==
                                                    false
                                                ? Colors.red
                                                : AppColors.PrimaryColor,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text(option['title'] +
                                                " [" +
                                                option['point'].toString() +
                                                " Points]"),
                                            subtitle: ExpandableText(
                                              option['description'],
                                              expandText: 'show more',
                                              collapseText: 'show less',
                                              maxLines: 2,
                                              linkColor: Colors.blue,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 12),
                                            ),
                                            value: isUserChecked(
                                                option['users'],
                                                'day${widget.ramadan_day}'),
                                            onChanged: (bool? newValue) {
                                              if (newValue != null) {
                                                updateUserTrackingOption(
                                                    option['_id'], newValue);
                                                if (!isUserChecked(
                                                    option['users'],
                                                    'day${widget.ramadan_day}')) {
                                                  //positive for chcek
                                                  addPoints(option['point']);
                                                } else {
                                                  //negetive for unchcek
                                                  addPoints(
                                                      option['point'] * -1);
                                                }
                                              }
                                            },
                                          );
                                  }).toList(),
                                )
                              ])))
                  : Container(); // Empty container for unsupported types or when type is not set
        } else {
          return Text("No options available");
        }
      },
    );
  }
}
